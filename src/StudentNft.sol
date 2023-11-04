// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "openzeppelin-contracts/contracts/token/ERC721/ERC721.sol";

import "./interfaces/IStudentNft.sol";
import "./interfaces/IEvaluator.sol";

contract StudentNft is IStudentNft, ERC721 {

    IEvaluator private evaluator;

    constructor(address _evaluatorAddress) ERC721("AntoineRevelNFT", "ARNFT"){
        evaluator = IEvaluator(_evaluatorAddress);
    }

    function mint(uint256 tokenIdToMint) external {
        uint256 approvedAmount = evaluator.allowance(msg.sender, address(this));

        require(approvedAmount > 0, "cannot mint nft without collateral");

        evaluator.transferFrom(msg.sender, address(this), approvedAmount);

        _mint(msg.sender, tokenIdToMint);
    }

    function burn(uint256 tokenIdToBurn) external{

    }
}
