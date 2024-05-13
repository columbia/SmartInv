1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.10;
3 
4 import "@openzeppelin/contracts/access/Ownable.sol";
5 
6 import "./TokenLock.sol";
7 
8 /// @dev Same as TokenLock, but enables a revoker to end vesting prematurely and send locked tokens to governance.
9 contract RevokableTokenLock is TokenLock {
10     address public revoker;
11 
12     event Revoked(address indexed revokedOwner, uint256 amount);
13 
14     constructor(ERC20 _token, address _revoker) TokenLock(_token) {
15         require(_revoker != address(0), "RevokableTokenLock: revoker address cannot be set to 0");
16         revoker = _revoker;
17     }
18 
19     /**
20      * @dev set revoker address
21      * @param _revoker The account with revoking rights
22      */
23     function setRevoker(address _revoker) external onlyOwner {
24         require(_revoker != address(0), "RevokableTokenLock: null address");
25         revoker = _revoker;
26     }
27 
28     /**
29      * @dev revoke access of a owner and transfer pending
30      * @param recipient The account whose access will be revoked.
31      */
32     function revoke(address recipient) external {
33         require(
34             msg.sender == revoker || msg.sender == owner(),
35             "RevokableTokenLock: onlyAuthorizedActors"
36         );
37 
38         // claim any vested but unclaimed parts for recipient first
39         uint256 claimable = claimableBalance(recipient);
40         if (claimable > 0) {
41             vesting[recipient].claimedAmounts += claimable;
42             require(token.transfer(recipient, claimable), "RevokableTokenLock: Transfer failed");
43             emit Claimed(recipient, recipient, claimable);
44         }
45 
46         // revoke the rest that is still being vested
47         uint256 remaining = vesting[recipient].lockedAmounts - vesting[recipient].claimedAmounts;
48         if (remaining > 0) {
49             require(token.transfer(owner(), remaining), "RevokableTokenLock: Transfer failed");
50             // no new claims
51             vesting[recipient].lockedAmounts = vesting[recipient].claimedAmounts;
52             vesting[recipient].unlockEnd = block.timestamp;
53         }
54         emit Revoked(recipient, remaining);
55     }
56 }
