// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.20;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {DecentralisedStableCoin} from "./DecentralisedStableCoin.sol";
import {ReentrancyGuard} from "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

/**
 * @title DSC Engine
 * @author Abhishek Alimchandani
 * @notice This is designed system to be as minimal as possible , and the tokens should maintain $1 peg value
 *
 * The stablecoin has the properties:
 * - Exogenous Collateral
 * - Dollar pegged
 * - Algorithmically Stable
 *
 * It is similar to DAI if DAI had no goveranance, no fees, and was only backed by wETH and wBTC
 *
 * Our DSCSystem should be always "overcollateralized". At no point,should the value of all colllateral <= the $ backed of all the DSC
 *
 * @notice It handles all the logic for the DSC as well ad deposit and withdraw of collateral
 */
contract DSCEngine is ReentrancyGuard {
    /////////////
    ////Errors///
    ////////////
    error DSCEngine__TransferFailed();
    error DSCEngine__NotAllowedToken();
    error DSCEngine__NeedsMoreThanZero();
    error DSCEngine__PriceFeedAddressAndTheTokenAddressesMustBeSameLength();

    ///////////////////
    //State Variables//
    ///////////////////
    mapping(address token => address priceFeed) private s_priceFeeds; //TokentoPriceFeed
    mapping(address user => mapping(address token => uint256 amount)) private s_collateralDeposited;
    mapping(address user => uint256 amountDSCMinted) private s_DSCMinted;

    address[] private s_collateralTokens;
    DecentralisedStableCoin private immutable i_dsc;

    ///////////
    //Events//
    //////////
    event CollateralDeposited(address indexed user, address indexed token, uint256 indexed amount);

    /////////////
    //Modifiers//
    ////////////

    modifier moreThanZero(uint256 amount) {
        if (amount == 0) {
            revert DSCEngine__NeedsMoreThanZero();
            _;
        }
    }

    modifier onlyAllowedToken(address token) {
        if (s_priceFeeds[token] == address(0)) {
            revert DSCEngine__NotAllowedToken();
        }
        _;
    }

    /////////////
    //Functions//
    ////////////

    constructor(address[] memory tokenAddresses, address[] memory priceFeedAddresses, address dscAddress) {
        if (tokenAddresses.length != priceFeedAddresses.length) {
            revert DSCEngine__PriceFeedAddressAndTheTokenAddressesMustBeSameLength();
        }

        //Setting the mapping s_priceFeeds
        for (uint256 i = 0; i < tokenAddresses.length; i++) {
            s_priceFeeds[tokenAddresses[i]] = priceFeedAddresses[i];
            s_collateralTokens.push(tokenAddresses[i]);
        }

        i_dsc = DecentralisedStableCoin(dscAddress);
    }

    /**
     *
     * @param tokenCollateralAddress The address of the token to deposit as a collateral
     * @param amountCollateral The amount of collateral to deposit
     */
    function depositCollateral(address tokenCollateralAddress, uint256 amountCollateral)
        external
        moreThanZero(amountCollateral)
        onlyAllowedToken(tokenCollateralAddress)
        nonReentrant
    {
        s_collateralDeposited[msg.sender][tokenCollateralAddress] += amountCollateral;
        emit CollateralDeposited(msg.sender, tokenCollateralAddress, amountCollateral);
        bool successs = IERC20(tokenCollateralAddress).transferFrom(msg.sender, address(this), amountCollateral);
        if (!successs) {
            revert DSCEngine__TransferFailed();
        }
    }

    /**
     *
     * @param amountDscToMint The amount of Decentralised stablecoin to mint
     * @notice Here we will have to include all price feeds and all to check if they have more collateral value than the minimum threshold
     */
    function mintDSC(uint256 amountDscToMint) external moreThanZero(amountDscToMint) nonReentrant {
        s_DSCMinted[msg.sender] += amountDscToMint;
    }

    //////////////////////
    //Internal Functions//
    /////////////////////

    function _getAccountInformation(address user)
        private
        view
        returns (uint256 totalDSCMinted, uint256 collateralValueInUSD)
    {
        totalDSCMinted = s_DSCMinted[user];
        collateralValueInUSD = getAccountCollateralValue(user);
    }

    /**
     * This function returns how close to liqudation a user is, If a user goes below 1 then they can get liqudated
     * @param user This is the address of the user
     */
    function _healthFactor(address user) private view returns (uint256) {
        //To calculate the health factor we need the TotalDSC minted and the total Collateral Value
        (uint256 totalDSCMinted, uint256 collateralValueInUSD) = _getAccountInformation(user);
    }

    function _revertIfHealthFactorIsBroken(address user) internal view {
        //Check health factor (do they have enough collateral)
        // Revert if they dont have good health factor
    }

    //////////////////////////////////////
    //Public and External View Functions//
    /////////////////////////////////////

    function getAccountCollateralValue(address user) private view returns (uint256) {
        /*
        To get the value of the collateral we need to do the following things
        1. Loop through each collateral token, get the amount they have deposited
        2. Map it to the price , to get the USD value
         */

        for (uint256 i = 0; i < s_collateralTokens.length; i++) {
            address token = s_collateralTokens[i];
            uint256 amount = s_collateralDeposited[user][token];
        }
    }

    function getUSDValue(address token, uint256 amount) public view returns (uint256) {}
}
