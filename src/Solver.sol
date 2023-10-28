// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
contract Solver is ERC20{
    mapping(address => bool) public isCustomerWhiteListed;
    mapping(address => uint256) public customerTierLevel;
    modifier onlyAllowedUsers() {
        require(isCustomerWhiteListed[msg.sender], "User not allowed");
        _;
    }
    constructor(string memory name, string memory symbol,uint256 initialSupply) ERC20(name, symbol) {
        isCustomerWhiteListed[msg.sender] = true;
        _mint(msg.sender, initialSupply);
    }
    function addToAllowlist(address user, uint256 tier) external onlyAllowedUsers {
        isCustomerWhiteListed[user] = true;
        customerTierLevel[user] = tier;
    }
    function getToken() external onlyAllowedUsers returns (bool) {
        _mint(msg.sender, 1000);
        return true;
    }

    function buyToken() external payable onlyAllowedUsers returns (bool) {
        require(msg.value > 0, "You must send some ETH to exchange for tokens");
        uint256 nbrOfTokensToMint;
        uint256 userTier = customerTierLevel[msg.sender];
        if (userTier == 1) {
            nbrOfTokensToMint = msg.value * 1 * 10 ** uint256(decimals());
        } else if (userTier == 2) {
            nbrOfTokensToMint = msg.value * 2 * 10 ** uint256(decimals());
        } else if (userTier == 3) {
            nbrOfTokensToMint = msg.value * 3 * 10 ** uint256(decimals());
        } else {
            revert("You are not allowed to call this function.");
        }
        _mint(msg.sender, nbrOfTokensToMint);
        return true;
    }
}
