1 pragma solidity >=0.5.10;
2 
3 
4 interface IERC20 {
5     function transfer(address recipient, uint256 amount) external returns (bool);
6     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
7     function balanceOf(address account) external view returns (uint256);
8     event Transfer(address indexed from, address indexed to, uint256 value);
9 }
10 
11 interface KNCLock {
12     function lock(uint qty, string calldata eosAddr, uint64 eosRecipientName) external;
13 }
14 
15 contract TriggerKNCLock {
16     
17     KNCLock public KNCLockContract = KNCLock(0x980358360409b1cc913A916bC0Bf6f52F775242A);
18     IERC20 public KNC = IERC20(0xdd974D5C2e2928deA5F71b9825b8b646686BD200);
19     
20     constructor(IERC20 knc) public {
21         
22         KNC = knc;
23     }
24     
25     function triggerLock(string memory eosAddr, uint64 eosRecipientName) public {
26         
27         uint qty = KNC.balanceOf(address(this)); 
28         
29         KNCLockContract.lock(qty, eosAddr, eosRecipientName);
30     }
31     
32     function setKNCLockAddress(KNCLock lockContract) public {
33         KNCLockContract = lockContract;
34     }
35 }