// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.20;

import {ERC20, ERC20Burnable} from "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
/**
 * @title Decentralised Stablecoin
 * @author Abhishek Alimchandani
 * @notice This is the contract mean to governed by the DSC Engine. This contract is just the ERC20 implementation of our stablecoin system.
 */

//As we have all the main logic of all the stuff in the DSCEngine so we want the DSCEngine contract to own this token contract so we have set it to Ownable
contract DecentralisedStableCoin is ERC20Burnable, Ownable {
    error DecentralisedStableCoin__AmountBurnShouldBeGreaterThanZero();
    error DecentralisedStableCoin__BurnAmountExceedsBalance();
    error DecentralisedStableCoin__NotZeroAddress();

    constructor(address initalOwner) ERC20("DecentralisedStableCoin", "DSC") Ownable(initalOwner) {}

    function burn(uint256 _amount) public override onlyOwner {
        uint256 balance = balanceOf(msg.sender);

        if (_amount <= 0) {
            revert DecentralisedStableCoin__AmountBurnShouldBeGreaterThanZero();
        }

        if (balance < _amount) {
            revert DecentralisedStableCoin__BurnAmountExceedsBalance();
        }

        //This super keyword is basically to tell to run the burn function from the parent class
        super.burn(_amount);
    }

    function mint(address _to, uint256 _amount) external onlyOwner returns (bool) {
        if (_to == address(0)) {
            revert DecentralisedStableCoin__NotZeroAddress();
        }

        if (_amount <= 0) {
            revert DecentralisedStableCoin__AmountBurnShouldBeGreaterThanZero();
        }

        _mint(_to, _amount);

        return true;
    }
}
