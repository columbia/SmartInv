1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9   address public owner;
10 
11 
12   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
13 
14 
15   /**
16    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
17    * account.
18    */
19   function Ownable() public {
20     owner = msg.sender;
21   }
22 
23   /**
24    * @dev Throws if called by any account other than the owner.
25    */
26   modifier onlyOwner() {
27     require(msg.sender == owner);
28     _;
29   }
30 
31   /**
32    * @dev Allows the current owner to transfer control of the contract to a newOwner.
33    * @param newOwner The address to transfer ownership to.
34    */
35   function transferOwnership(address newOwner) public onlyOwner {
36     require(newOwner != address(0));
37     OwnershipTransferred(owner, newOwner);
38     owner = newOwner;
39   }
40 
41 }
42 
43 contract InsightsNetworkContributions is Ownable {
44 
45     string public name;
46     uint256 public cap;
47     uint256 public contributionMinimum;
48     uint256 public contributionMaximum;
49     uint256 public gasPriceMaximum;
50 
51     bool enabled;
52     uint256 total;
53 
54     mapping (address => bool) public registered;
55     mapping (address => uint256) public balances;
56 
57     event Approval(address indexed account, bool valid);
58     event Contribution(address indexed contributor, uint256 amount);
59     event Transfer(address indexed recipient, uint256 amount, address owner);
60 
61     function InsightsNetworkContributions(string _name, uint256 _cap, uint256 _contributionMinimum, uint256 _contributionMaximum, uint256 _gasPriceMaximum) public {
62         require(_contributionMinimum <= _contributionMaximum);
63         require(_contributionMaximum > 0);
64         require(_contributionMaximum <= _cap);
65         name = _name;
66         cap = _cap;
67         contributionMinimum = _contributionMinimum;
68         contributionMaximum = _contributionMaximum;
69         gasPriceMaximum = _gasPriceMaximum;
70         enabled = false;
71     }
72 
73     function () external payable {
74         contribute();
75     }
76 
77     function contribute() public payable {
78         require(enabled);
79         require(tx.gasprice <= gasPriceMaximum);
80         address sender = msg.sender;
81         require(registered[sender]);
82         uint256 value = msg.value;
83         uint256 balance = balances[sender] + value;
84         require(balance >= contributionMinimum);
85         require(balance <= contributionMaximum);
86         require(total + value <= cap);
87         balances[sender] = balance;
88         total += value;
89         Contribution(sender, value);
90     }
91 
92     function enable(bool _enabled) public onlyOwner {
93         enabled = _enabled;
94     }
95 
96     function register(address account, bool valid) public onlyOwner {
97         require(account != 0);
98         registered[account] = valid;
99         Approval(account, valid);
100     }
101 
102     function registerMultiple(address[] accounts, bool valid) public onlyOwner {
103         require(accounts.length <= 128);
104         for (uint index = 0; index < accounts.length; index++) {
105             address account = accounts[index];
106             require(account != 0);
107             registered[account] = valid;
108             Approval(account, valid);
109         }
110     }
111 
112     function transfer(address recipient, uint256 amount) public onlyOwner {
113         require(recipient != 0);
114         require(amount <= this.balance);
115         Transfer(recipient, amount, owner);
116         recipient.transfer(amount);
117     }
118 
119     function selfDestruct() public onlyOwner {
120         require(!enabled);
121         require(this.balance == 0);
122         selfdestruct(owner);
123     }
124 
125 }