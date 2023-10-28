// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.21;

import {IERC721} from "openzeppelin-contracts/contracts/token/ERC721/IERC721.sol";

interface IStudentNft is IERC721 {
    function mint(uint256 tokenIdToMint) external;

    function burn(uint256 tokenIdToBurn) external;
}