1 contract ElcoinDb {
2     address owner;
3     address caller;
4 
5     event Transaction(bytes32 indexed hash, address indexed from, address indexed to, uint time, uint amount);
6 
7     modifier checkOwner() { if(msg.sender == owner) { _ } else { return; } }
8     modifier checkCaller() { if(msg.sender == caller) { _ } else { return; } }
9     mapping (address => uint) public balances;
10 
11     function ElcoinDb(address pCaller) {
12         owner = msg.sender;
13         caller = pCaller;
14     }
15 
16     function getOwner() constant returns (address rv) {
17         return owner;
18     }
19 
20     function getCaller() constant returns (address rv) {
21         return caller;
22     }
23 
24     function setCaller(address pCaller) checkOwner() returns (bool _success) {
25         caller = pCaller;
26 
27         return true;
28     }
29 
30     function setOwner(address pOwner) checkOwner() returns (bool _success) {
31         owner = pOwner;
32 
33         return true;
34     }
35 
36     function getBalance(address addr) constant returns(uint balance) {
37         return balances[addr];
38     }
39 
40     function deposit(address addr, uint amount, bytes32 hash, uint time) checkCaller() returns (bool res) {
41         balances[addr] += amount;
42         Transaction(hash,0 , addr, time, amount);
43 
44         return true;
45     }
46 
47     function withdraw(address addr, uint amount, bytes32 hash, uint time) checkCaller() returns (bool res) {
48         uint oldBalance = balances[addr];
49         if(oldBalance >= amount) {
50             msg.sender.send(amount);
51             balances[addr] = oldBalance - amount;
52             Transaction(hash, addr, 0, time, amount);
53             return true;
54         }
55 
56         return false;
57     }
58 }