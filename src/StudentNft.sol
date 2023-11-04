// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "openzeppelin-contracts/contracts/token/ERC721/ERC721.sol";

import "./interfaces/IStudentNft.sol";

contract StudentNft is IStudentNft, ERC721 {
    constructor() ERC721("AntoineRevelNFT", "ARNFT"){

    }

    function mint(uint256 tokenIdToMint) external{
        //transferFrom(msg.sender,) //je veux récupérer le montantant maximum que le msg.sender a approve et ensuite lui mint le token d'id tokenIdToMint

    }

    function burn(uint256 tokenIdToBurn) external{

    }
}
