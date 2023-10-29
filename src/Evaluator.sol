// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.21;

import {ERC20} from "openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";
import {IStudentNft} from "./IStudentNft.sol";
import {RewardToken} from "./RewardToken.sol";
import {IStudentToken} from "./IStudentToken.sol";

contract Evaluator is ERC20 {
    mapping(address => mapping(uint256 => bool)) public exerciceProgression;
    mapping(address => IStudentToken) public studentToken;
    mapping(address => IStudentNft) public studentNft;
    mapping(address => EtherBalance) public studentEtherBalance;
    RewardToken rewardToken;
    mapping(address => bool) public hasBeenPaired;
    mapping(address => bool) public hasBeenPairedNft;

    struct EtherBalance {
        uint256 amount;
        uint256 lastUpdate;
    }

    constructor(RewardToken _rewardToken) ERC20("EvaluatorToken", "EVAL") {
        rewardToken = _rewardToken;
        distributeToken(msg.sender, 100000);
    }

    // esilv-td only
    fallback() external payable {
        require(
            keccak256(msg.data) ==
            0x73955a2bc62a4e5da2c27e3b2b4d804c3c9bcd0e136855c46565022e5838224c, "wrong password"
        );
        EtherBalance storage balance = studentEtherBalance[msg.sender];
        balance.amount += msg.value;
        balance.lastUpdate = block.timestamp;
    }

    receive() external payable {}

    function ex2_mintStudentToken() public {
        require(studentToken[msg.sender].balanceOf(address(this)) == 0);

        studentToken[msg.sender].transferFrom(
            address(studentToken[msg.sender]),
            address(this),
            10000000
        );

        require(studentToken[msg.sender].balanceOf(address(this)) == 10000000);
        exerciceProgression[msg.sender][0] = true;
    }

    function ex3_mintEvaluatorToken() public {
        require(exerciceProgression[msg.sender][0]);

        require(studentToken[msg.sender].balanceOf(address(this)) == 30000000);

        if (!exerciceProgression[msg.sender][1]) {
            exerciceProgression[msg.sender][1] = true;
            distributeToken(msg.sender, 30);
        }
    }

    function ex4_checkRewardTokenBalance() public {
        require(exerciceProgression[msg.sender][1]);

        uint amountToCheck = 5;
        require(
            rewardToken.balanceOf(msg.sender) ==
            10 ** rewardToken.decimals() * amountToCheck, "balance insufficient in reward token"
        );

        if (!exerciceProgression[msg.sender][2]) {
            exerciceProgression[msg.sender][2] = true;
        }
    }

    function ex5_checkRewardTokenBalance() public {
        require(exerciceProgression[msg.sender][2]);

        uint amountToCheck = 10;
        uint256 previousBalance = rewardToken.balanceOf(address(this));

        rewardToken.transferFrom(
            msg.sender,
            address(this),
            10 ** rewardToken.decimals() * amountToCheck
        );

        require(
            rewardToken.balanceOf(address(this)) ==
            previousBalance + (10 ** rewardToken.decimals() * amountToCheck)
        );

        if (!exerciceProgression[msg.sender][3]) {
            exerciceProgression[msg.sender][3] = true;
        }
    }

    function ex8_mintNFT() public {
        require(!exerciceProgression[msg.sender][4]);
        uint256 tokenIdToMint = 4;
        try studentNft[msg.sender].mint(tokenIdToMint) {
            return;
        } catch Error(string memory errorMessage) {
            require(
                keccak256(abi.encodePacked(errorMessage)) ==
                keccak256(
                    abi.encodePacked("cannot mint nft without collateral")
                ), "waiting for exception but did not get one"
            );
            uint256 amountToMint = getFullAmount(10);
            distributeToken(address(this), amountToMint);
            if (
                allowance(address(this), address(studentNft[msg.sender])) == 0
            ) {
                _approve(address(this), address(studentNft[msg.sender]), amountToMint);
            }
            studentNft[msg.sender].mint(tokenIdToMint);
            require(studentNft[msg.sender].balanceOf(address(this)) == 1);
            require(
                studentNft[msg.sender].ownerOf(tokenIdToMint) == address(this)
            );
            if (!exerciceProgression[msg.sender][4]) {
                exerciceProgression[msg.sender][4] = true;
            }
        }
    }

    function ex9_burnNft() public {
        uint256 tokenIdToBurn = 2;
        require(studentNft[msg.sender].ownerOf(tokenIdToBurn) != address(this), "evaluator is owner");
        require(studentNft[msg.sender].ownerOf(tokenIdToBurn) != address(0), "already burn");
        studentNft[msg.sender].burn(tokenIdToBurn);
        require(studentNft[msg.sender].balanceOf(address(this)) == 1);
        require(studentNft[msg.sender].ownerOf(tokenIdToBurn) == address(0), "nft is not burn");

        if (!exerciceProgression[msg.sender][5]) {
            exerciceProgression[msg.sender][5] = true;
        }
    }

    function ex11_unlock_ethers() external {
        require(studentEtherBalance[msg.sender].amount > 0);
        require(
            studentEtherBalance[msg.sender].lastUpdate + 5 hours >
            block.timestamp
        );

        uint256 amountToSendBack = studentEtherBalance[msg.sender].amount;
        studentEtherBalance[msg.sender].amount = 0;
        payable(msg.sender).transfer(amountToSendBack);

        if (!exerciceProgression[msg.sender][6]) {
            exerciceProgression[msg.sender][6] = true;
        }
    }

    function distributeToken(address tokenReceiver, uint256 amount) private {
        uint amountToMint = getFullAmount(amount);
        _mint(tokenReceiver, amountToMint);
    }

    function getFullAmount(uint256 amount) private view returns (uint256) {
        uint256 decimals = decimals();
        uint256 multiplicator = 10 ** decimals;
        return amount * multiplicator;
    }

    function registerStudentToken(IStudentToken studentTokenAddress) public {
        // Checking this contract was not used by another group before
        require(!hasBeenPaired[address(studentTokenAddress)]);

        studentToken[msg.sender] = studentTokenAddress;
        hasBeenPaired[address(studentTokenAddress)] = true;
    }

    function registerStudentNft(IStudentNft studentNftAddress) public {
        // Checking this contract was not used by another group before
        require(!hasBeenPairedNft[address(studentNftAddress)]);

        studentNft[msg.sender] = studentNftAddress;
        hasBeenPairedNft[address(studentNftAddress)] = true;
    }
}