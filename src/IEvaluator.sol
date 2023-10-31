// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.21;

interface IEvaluator {
    function balanceOf(address account) external view returns (uint256);

    function exerciceProgression(address, uint256) external view returns (bool);
    function studentToken(address) external view returns (address);
    function studentNft(address) external view returns (address);
    function studentEtherBalance(address) external view returns (uint256 amount, uint256 lastUpdate);
    function hasBeenPaired(address) external view returns (bool);
    function hasBeenPairedNft(address) external view returns (bool);

    function ex2_mintStudentToken() external;
    function ex3_mintEvaluatorToken() external;
    function ex4_checkRewardTokenBalance() external;
    function ex5_checkRewardTokenBalance() external;
    function ex8_mintNFT() external;
    function ex9_burnNft() external;
    function ex11_unlock_ethers() external;
    function registerStudentToken(address studentTokenAddress) external;
    function registerStudentNft(address studentNftAddress) external;
}
