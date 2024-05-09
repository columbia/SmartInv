1 pragma solidity 0.4.16;
2 
3 contract Escrow{
4     
5     function Escrow() {
6         owner = msg.sender;
7     }
8 
9     mapping (address => mapping (bytes32 => uint128)) public balances;
10     mapping (bytes16 => Lock) public lockedMoney;
11     address public owner;
12     
13     struct Lock {
14         uint128 amount;
15         bytes32 currencyAndBank;
16         address from;
17         address executingBond;
18     }
19     
20     event TxExecuted(uint32 indexed event_id);
21     
22     modifier onlyOwner() {
23         if(msg.sender == owner)
24         _;
25     }
26     
27     function checkBalance(address acc, string currencyAndBank) constant returns (uint128 balance) {
28         bytes32 cab = sha3(currencyAndBank);
29         return balances[acc][cab];
30     }
31     
32     function getLocked(bytes16 lockID) returns (uint) {
33         return lockedMoney[lockID].amount;
34     }
35     
36     function deposit(address to, uint128 amount, string currencyAndBank, uint32 event_id) 
37         onlyOwner returns(bool success) {
38             bytes32 cab = sha3(currencyAndBank);
39             balances[to][cab] += amount;
40             TxExecuted(event_id);
41             return true;
42     } 
43     
44     function withdraw(uint128 amount, string currencyAndBank, uint32 event_id) 
45         returns(bool success) {
46             bytes32 cab = sha3(currencyAndBank);
47             require(balances[msg.sender][cab] >= amount);
48             balances[msg.sender][cab] -= amount;
49             TxExecuted(event_id);
50             return true;
51     }
52     
53     function lock(uint128 amount, string currencyAndBank, address executingBond, bytes16 lockID, uint32 event_id) 
54         returns(bool success) {   
55             bytes32 cab = sha3(currencyAndBank);
56             require(balances[msg.sender][cab] >= amount);
57             balances[msg.sender][cab] -= amount;
58             lockedMoney[lockID].currencyAndBank = cab;
59             lockedMoney[lockID].amount += amount;
60             lockedMoney[lockID].from = msg.sender;
61             lockedMoney[lockID].executingBond = executingBond;
62             TxExecuted(event_id);
63             return true; 
64     }
65     
66     function executeLock(bytes16 lockID, address issuer) returns(bool success) {
67         if(msg.sender == lockedMoney[lockID].executingBond){
68 	        balances[issuer][lockedMoney[lockID].currencyAndBank] += lockedMoney[lockID].amount;            
69 	        delete lockedMoney[lockID];
70 	        return true;
71 		}else
72 		    return false;
73     }
74     
75     function unlock(bytes16 lockID, uint32 event_id) onlyOwner returns (bool success) {
76         balances[lockedMoney[lockID].from][lockedMoney[lockID].currencyAndBank] +=
77             lockedMoney[lockID].amount;
78         delete lockedMoney[lockID];
79         TxExecuted(event_id);
80         return true;
81     }
82     
83     function pay(address to, uint128 amount, string currencyAndBank, uint32 event_id) 
84         returns (bool success){
85             bytes32 cab = sha3(currencyAndBank);
86             require(balances[msg.sender][cab] >= amount);
87             balances[msg.sender][cab] -= amount;
88             balances[to][cab] += amount;
89             TxExecuted(event_id);
90             return true;
91     }
92 }