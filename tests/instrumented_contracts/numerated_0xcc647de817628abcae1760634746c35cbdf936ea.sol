1 pragma solidity ^0.4.18;
2 
3 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11   address public owner;
12 
13 
14   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
15 
16 
17   /**
18    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
19    * account.
20    */
21   function Ownable() public {
22     owner = msg.sender;
23   }
24 
25   /**
26    * @dev Throws if called by any account other than the owner.
27    */
28   modifier onlyOwner() {
29     require(msg.sender == owner);
30     _;
31   }
32 
33   /**
34    * @dev Allows the current owner to transfer control of the contract to a newOwner.
35    * @param newOwner The address to transfer ownership to.
36    */
37   function transferOwnership(address newOwner) public onlyOwner {
38     require(newOwner != address(0));
39     OwnershipTransferred(owner, newOwner);
40     owner = newOwner;
41   }
42 
43 }
44 
45 // File: contracts/InsightsNetworkContributions.sol
46 
47 contract InsightsNetworkContributions is Ownable {
48 
49     string public name;
50     uint256 public cap;
51     uint256 public contributionMinimum;
52     uint256 public contributionMaximum;
53     uint256 public gasPriceMaximum;
54 
55     bool enabled;
56     uint256 total;
57 
58     mapping (address => bool) public registered;
59     mapping (address => uint256) public balances;
60 
61     event Approval(address indexed account, bool valid);
62     event Contribution(address indexed contributor, uint256 amount);
63     event Transfer(address indexed recipient, uint256 amount, address owner);
64 
65     function InsightsNetworkContributions(string _name, uint256 _cap, uint256 _contributionMinimum, uint256 _contributionMaximum, uint256 _gasPriceMaximum) public {
66         require(_contributionMinimum <= _contributionMaximum);
67         require(_contributionMaximum > 0);
68         require(_contributionMaximum <= _cap);
69         name = _name;
70         cap = _cap;
71         contributionMinimum = _contributionMinimum;
72         contributionMaximum = _contributionMaximum;
73         gasPriceMaximum = _gasPriceMaximum;
74         enabled = false;
75     }
76 
77     function () external payable {
78         contribute();
79     }
80 
81     function contribute() public payable {
82         require(enabled);
83         require(tx.gasprice <= gasPriceMaximum);
84         address sender = msg.sender;
85         require(registered[sender]);
86         uint256 value = msg.value;
87         uint256 balance = balances[sender] + value;
88         require(balance >= contributionMinimum);
89         require(balance <= contributionMaximum);
90         require(total + value <= cap);
91         balances[sender] = balance;
92         total += value;
93         Contribution(sender, value);
94     }
95 
96     function enable(bool _enabled) public onlyOwner {
97         enabled = _enabled;
98     }
99 
100     function register(address account, bool valid) public onlyOwner {
101         require(account != 0);
102         registered[account] = valid;
103         Approval(account, valid);
104     }
105 
106     function registerMultiple(address[] accounts, bool valid) public onlyOwner {
107         require(accounts.length <= 128);
108         for (uint index = 0; index < accounts.length; index++) {
109             address account = accounts[index];
110             require(account != 0);
111             registered[account] = valid;
112             Approval(account, valid);
113         }
114     }
115 
116     function transfer(address recipient, uint256 amount) public onlyOwner {
117         require(recipient != 0);
118         require(amount <= this.balance);
119         Transfer(recipient, amount, owner);
120         recipient.transfer(amount);
121     }
122 
123     function selfDestruct() public onlyOwner {
124         require(!enabled);
125         require(this.balance == 0);
126         selfdestruct(owner);
127     }
128 
129 }