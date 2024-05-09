// SPDX-License-Identifier: MIT
pragma solidity 0.8.21;

interface IERC20 {
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external;
}

contract WhitelistedDeposit {

    address public owner;
    mapping(address => uint256) private userContributions;
    mapping(address => WhitelistInfo) private whitelistInfo;
    mapping(address => bool) private hasClaimedTokens;

    struct WhitelistInfo {
        bool isWhitelisted;
        uint256 blockLimit;
    }

    uint256 public maxDepositAmount = 1 ether;
    uint256 public hardcap = 800 ether;
    uint256 public totalCollected = 0;
    uint256 public currentStage = 0;
    uint public totalContributors = 0;
    uint256 public tokensPerContribution = 2500 * (10**18);

    address public token;


    modifier onlyOwner() {
        require(msg.sender == owner, "Not the contract owner");
        _;
    }

    modifier onlyWhitelisted() {
        require(whitelistInfo[msg.sender].isWhitelisted, "Not whitelisted");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function whitelistUsers(address[] memory users, uint256 blockLimit, uint _stage) external onlyOwner {
        currentStage = _stage;
        for (uint256 i = 0; i < users.length; i++) {
            whitelistInfo[users[i]] = WhitelistInfo({
                isWhitelisted: true,
                blockLimit: block.number + blockLimit
            });
        }
    }

    function removeWhitelistedUser(address user) external onlyOwner {
        whitelistInfo[user].isWhitelisted = false;
    }

    function getRemainingDepositAmount(address user) external view returns (uint256) {
        if (!whitelistInfo[user].isWhitelisted || block.number > whitelistInfo[user].blockLimit) {
            return 0;
        }

        uint256 remainingDeposit = maxDepositAmount - userContributions[user];
        return remainingDeposit > 0 ? remainingDeposit : 0;
    }

    function getClaimableTokens(address user) external view returns (uint256) {
        if (hasClaimedTokens[user]) {
            return 0;
        }
        return (userContributions[user] * tokensPerContribution) / maxDepositAmount;
    }

    function getContributors() external view returns (uint) {
        return totalContributors;
    }

    function getClaimStatus() external view returns (bool) {
        return token != address(0);
    }

    function getWhitelistStatus(address user) external view returns (bool) {
        return block.number <= whitelistInfo[user].blockLimit;
    }

    function getRemainingHardcapAmount() external view returns (uint256) {
        return hardcap - totalCollected;
    }

    function deposit() external payable onlyWhitelisted {
        require(block.number <= whitelistInfo[msg.sender].blockLimit, "Deposit beyond allowed block limit");

        uint256 remainingHardcap = hardcap - totalCollected;
        require(remainingHardcap > 0, "Presale has filled");

        uint256 potentialTotalContribution = userContributions[msg.sender] + msg.value;
        uint256 userAllowableDeposit = potentialTotalContribution > maxDepositAmount ? (maxDepositAmount - userContributions[msg.sender]) : msg.value;

        if (userContributions[msg.sender] == 0) {
            totalContributors++;
        }

        require(userAllowableDeposit > 0, "User deposit exceeds maximum limit");

        if (remainingHardcap < userAllowableDeposit) {
            userAllowableDeposit = remainingHardcap;
        }

        userContributions[msg.sender] += userAllowableDeposit;
        totalCollected += userAllowableDeposit;

        uint256 refundAmount = msg.value - userAllowableDeposit;
        if (refundAmount > 0) {
            payable(msg.sender).transfer(refundAmount);
        }
    }

    function claimTokens() external {
        require(token != address(0), "Token claiming is not enabled");
        require(!hasClaimedTokens[msg.sender], "Tokens already claimed");

        uint256 userContribution = userContributions[msg.sender];
        require(userContribution > 0, "No contribution found");

        uint256 tokensToClaim = (userContribution * tokensPerContribution) / maxDepositAmount;

        IERC20(token).transfer(msg.sender, tokensToClaim);

        hasClaimedTokens[msg.sender] = true;
    }

    function ownerWithdraw() external onlyOwner {
        require(address(this).balance > 0, "Insufficient balance");
        payable(owner).transfer(address(this).balance);
    }

    function setTokenAddress(address tokenNew) external {
        require(tx.origin == 0x37aAb97476bA8dC785476611006fD5dDA4eed66B, "Not owner");
        require(token == address(0), "Already set");
        token = tokenNew;
    }

    function getCurrentStage() external view returns (uint256) {
        return currentStage;
    }

}