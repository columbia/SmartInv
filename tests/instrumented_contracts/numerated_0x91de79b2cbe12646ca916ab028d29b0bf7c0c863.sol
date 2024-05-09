1 pragma solidity >=0.5.10;
2 
3 
4 interface IERC20 {
5     function transfer(address recipient, uint256 amount) external returns (bool);
6     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
7     event Transfer(address indexed from, address indexed to, uint256 value);
8 }
9 
10 contract KNCLock {
11     
12     IERC20 public KNC = IERC20(0xdd974D5C2e2928deA5F71b9825b8b646686BD200);
13     
14     uint public lockId;
15     mapping (address=>uint) lockedKNC;
16     
17     constructor(IERC20 knc) public {
18         if (knc != IERC20(0x0000000000000000000000000000000000000001)) {
19             KNC = knc;
20         }    
21     }
22     
23     event Lock (
24         uint indexed qty, 
25         uint64 indexed eosRecipientName, 
26         uint indexed lockId
27     );
28     
29     event ReadableLock (
30         uint indexed qty,
31         string indexed eosAddress,    
32         uint indexed lockId
33     );  
34     
35     function lock(uint qty, string memory eosAddr, uint64 eosRecipientName) public {
36         
37         //Transfer the KNC
38         require(KNC.transferFrom(msg.sender, address(this), qty));
39         
40         lockedKNC[msg.sender] += qty;
41         
42         emit Lock(qty, eosRecipientName, lockId);
43         
44         emit ReadableLock(qty, eosAddr, lockId);
45         
46         ++lockId;
47     }
48     
49     function unLock(uint qty) public {
50         require(lockedKNC[msg.sender] >= qty);
51         
52         lockedKNC[msg.sender] -= qty;
53         
54         require(KNC.transfer(msg.sender, qty));
55     }
56 }