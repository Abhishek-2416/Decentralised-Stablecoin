// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.20;

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
contract DSCEngine {}
