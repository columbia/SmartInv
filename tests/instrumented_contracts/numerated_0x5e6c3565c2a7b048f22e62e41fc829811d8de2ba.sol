1 pragma solidity 0.4.24;
2 
3 
4 contract SnooKarma {
5     
6     //The oracle checks the authenticity of the Reddit accounts and their karma
7     address public oracle;
8     
9     //The maintainer manages donations and a small Karma fee
10     //The maintainer is in charge of keeping the oracle running
11     address public maintainer;
12     
13     //The owner can replace the oracle or maintainer if they are compromised
14     address public owner;
15     
16     //ERC20 code
17     //See https://github.com/ethereum/EIPs/blob/e451b058521ba6ccd5d3205456f755b1d2d52bb8/EIPS/eip-20.md
18     mapping(address => uint) public balanceOf;
19     mapping(address => mapping (address => uint)) public allowance;
20     string public constant symbol = "SNK";
21     string public constant name = "SnooKarma";
22     uint8 public constant decimals = 2;
23     uint public totalSupply = 0;
24     event Transfer(address indexed _from, address indexed _to, uint _value);
25     event Approval(address indexed _owner, address indexed _spender, uint _value);
26    
27     //The Redeem event is activated when a Reddit user redeems Karma Coins
28     event Redeem(string indexed username, address indexed addr, uint karma);
29     //END OF ERC20 code
30  
31     //Keep track of Reddit users and their redeemed karma amount
32     mapping(string => uint) redeemedKarma;
33     
34     //Construct the contract
35     constructor() public {
36         owner = msg.sender;
37         maintainer = msg.sender;
38         oracle = msg.sender;
39     }
40     
41     //ERC20 code
42     //See https://github.com/ethereum/EIPs/blob/e451b058521ba6ccd5d3205456f755b1d2d52bb8/EIPS/eip-20.md
43     function transfer(address destination, uint amount) public returns (bool success) {
44         if (balanceOf[msg.sender] >= amount && 
45             balanceOf[destination] + amount > balanceOf[destination]) {
46             balanceOf[msg.sender] -= amount;
47             balanceOf[destination] += amount;
48             emit Transfer(msg.sender, destination, amount);
49             return true;
50         } else {
51             return false;
52         }
53     }
54  
55     function transferFrom (
56         address from,
57         address to,
58         uint amount
59     ) public returns (bool success) {
60         if (balanceOf[from] >= amount &&
61             allowance[from][msg.sender] >= amount &&
62             balanceOf[to] + amount > balanceOf[to]) 
63         {
64             balanceOf[from] -= amount;
65             allowance[from][msg.sender] -= amount;
66             balanceOf[to] += amount;
67             emit Transfer(from, to, amount);
68             return true;
69         } else {
70             return false;
71         }
72     }
73  
74     function approve(address spender, uint amount) public returns (bool success) {
75         allowance[msg.sender][spender] = amount;
76         emit Approval(msg.sender, spender, amount);
77         return true;
78     }
79     //END OF ERC20 code
80     
81     //SafeAdd function from 
82     //https://github.com/OpenZeppelin/zeppelin-solidity/blob/6ad275befb9b24177b2a6a72472673a28108937d/contracts/math/SafeMath.sol
83     function safeAdd(uint a, uint b) internal pure returns (uint) {
84         uint c = a + b;
85         require(c >= a);
86         return c;
87     }
88     
89     //Used to enforce permissions
90     modifier onlyBy(address account) {
91         require(msg.sender == account);
92         _;
93     }
94     
95     //The owner can transfer ownership
96     function transferOwnership(address newOwner) public onlyBy(owner) {
97         require(newOwner != address(0));
98         owner = newOwner;
99     }
100     
101     //The owner can change the oracle
102     //This works only if removeOracle() was never called
103     function changeOracle(address newOracle) public onlyBy(owner) {
104         require(oracle != address(0) && newOracle != address(0));
105         oracle = newOracle;
106     }
107 
108     //The owner can remove the oracle
109     //This can not be reverted and stops the generation of new SnooKarma coins!
110     function removeOracle() public onlyBy(owner) {
111         oracle = address(0);
112     }
113     
114     //The owner can change the maintainer
115     function changeMaintainer(address newMaintainer) public onlyBy(owner) {
116         maintainer = newMaintainer;
117     }
118     
119     //Allows the user the redeem an amount of Karma verified by the oracle
120     //This function also grants a small extra amount of Karma to the maintainer
121     //The maintainer gets 1 extra karma for each 100 redeemed by a user
122     function redeem(string username, uint karma, uint sigExp, uint8 sigV, bytes32 sigR, bytes32 sigS) public {
123         //The identity of the oracle is checked
124         require(
125             ecrecover(
126                 keccak256(abi.encodePacked(this, username, karma, sigExp)),
127                 sigV, sigR, sigS
128             ) == oracle
129         );
130         //The signature must not be expired
131         require(block.timestamp < sigExp);
132         //The amount of karma needs to be more than the previous redeemed amount
133         require(karma > redeemedKarma[username]);
134         //The new karma that is available to be redeemed
135         uint newUserKarma = karma - redeemedKarma[username];
136         //The user's karma balance is updated with the new karma
137         balanceOf[msg.sender] = safeAdd(balanceOf[msg.sender], newUserKarma);
138         //The maintainer's extra karma is computed (1 extra karma for each 100 redeemed by a user)
139         uint newMaintainerKarma = newUserKarma / 100;
140         //The balance of the maintainer is updated
141         balanceOf[maintainer] = safeAdd(balanceOf[maintainer], newMaintainerKarma);
142         //The total supply (ERC20) is updated
143         totalSupply = safeAdd(totalSupply, safeAdd(newUserKarma, newMaintainerKarma));
144         //The amount of karma redeemed by a user is updated
145         redeemedKarma[username] = karma;
146         //The Redeem event is triggered
147         emit Redeem(username, msg.sender, newUserKarma);
148     }
149     
150     //This function is a workaround because this.redeemedKarma cannot be public
151     //This is the limitation of the current Solidity compiler
152     function redeemedKarmaOf(string username) public view returns(uint) {
153         return redeemedKarma[username];
154     }
155     
156     //Receive donations
157     function() public payable {  }
158     
159     //Transfer donations or accidentally received Ethereum
160     function transferEthereum(uint amount, address destination) public onlyBy(maintainer) {
161         require(destination != address(0));
162         destination.transfer(amount);
163     }
164 
165     //Transfer donations or accidentally received ERC20 tokens
166     function transferTokens(address token, uint amount, address destination) public onlyBy(maintainer) {
167         require(destination != address(0));
168         SnooKarma tokenContract = SnooKarma(token);
169         tokenContract.transfer(destination, amount);
170     }
171  
172 }