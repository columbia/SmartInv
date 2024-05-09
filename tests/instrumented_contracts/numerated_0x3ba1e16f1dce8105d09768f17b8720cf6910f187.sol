1 pragma solidity >=0.5.10;
2 
3 
4 interface IERC20 {
5     function transfer(address recipient, uint256 amount) external returns (bool);
6     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
7     function balanceOf(address account) external view returns (uint256);
8     function approve(address spender, uint256 amount) external returns (bool);
9     event Transfer(address indexed from, address indexed to, uint256 value);
10 }
11 
12 interface KNCLock {
13     function lock(uint qty, string calldata eosAddr, uint64 eosRecipientName) external;
14 }
15 
16 contract TriggerKNCLock {
17     
18     KNCLock public KNCLockContract = KNCLock(0x980358360409b1cc913A916bC0Bf6f52F775242A);
19     IERC20 public KNC = IERC20(0xdd974D5C2e2928deA5F71b9825b8b646686BD200);
20     
21     constructor(IERC20 knc) public {
22         
23         KNC = knc;
24     }
25     
26     function triggerLock(string memory eosAddr, uint64 eosRecipientName) public {
27         
28         uint qty = KNC.balanceOf(address(this)); 
29         
30         KNC.approve(address(KNCLockContract), qty);
31         
32         KNCLockContract.lock(qty, eosAddr, eosRecipientName);
33     }
34     
35     function setKNCLockAddress(KNCLock lockContract) public {
36         KNCLockContract = lockContract;
37     }
38 }