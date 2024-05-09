1 pragma solidity ^0.4.16;
2 
3 contract AbstractENS {
4     function owner(bytes32 node) public constant returns(address);
5 }
6 contract ReverseRegistrar {
7     function claim(address owner) public returns (bytes32);
8 }
9 
10 contract owned {
11     address public owner;
12     address public admin;
13 
14     function rens() internal {
15 	AbstractENS ens = AbstractENS(0x314159265dD8dbb310642f98f50C066173C1259b); // ENS addr
16 	ReverseRegistrar registrar = ReverseRegistrar(ens.owner(0x91d1777781884d03a6757a803996e38de2a42967fb37eeaca72729271025a9e2)); // namehash('addr.reverse')
17 	if(address(registrar) != 0)
18 	    registrar.claim(owner);
19     }
20 
21     function owned() public {
22         owner = msg.sender;
23         admin = msg.sender;
24         rens();
25     }
26 
27     modifier onlyOwner {
28         require(msg.sender == owner);
29         _;
30     }
31 
32     modifier onlyAdmin {
33         require(msg.sender == admin || msg.sender == owner);
34         _;
35     }
36 
37     function transferOwnership(address newOwner) onlyOwner public {
38         owner = newOwner;
39         rens();
40     }
41 
42     function setAdmin(address newAdmin) onlyOwner public {
43         admin = newAdmin;
44     }
45 }
46 
47 contract RichiumToken is owned {
48     string public name;
49     string public symbol;
50     uint8 public decimals = 18;
51     uint256 public totalSupply;
52 
53     mapping (address => uint256) public balanceOf;
54 
55     mapping (address => bool) public approvedAccount;
56     
57     event ApprovedAccount(address target, bool approve);
58     event Transfer(address indexed from, address indexed to, uint256 value);
59     event Burn(address indexed from, uint256 value);
60     
61     uint256 public bid;
62     uint256 public ask;
63 
64     function RichiumToken(uint256 initialSupply, string tokenName, string tokenSymbol) public {
65         totalSupply = initialSupply * (10 ** uint256(decimals));
66         balanceOf[msg.sender] = totalSupply;
67         name = tokenName;
68         symbol = tokenSymbol;
69 
70 	approvedAccount[msg.sender] = true;
71     }
72 
73     // Internal transfer, only called by this contract
74     function _transfer(address _from, address _to, uint _value) internal {
75         require(_to != 0x0);
76         require(balanceOf[_from] >= _value);
77         require(balanceOf[_to] + _value > balanceOf[_to]);
78         require(approvedAccount[_from]);
79         require(approvedAccount[_to]);
80 
81         uint256 previousBalances = balanceOf[_from] + balanceOf[_to];
82         balanceOf[_from] -= _value;
83         balanceOf[_to] += _value;
84         emit Transfer(_from, _to, _value);
85         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
86     }
87 
88     /**
89      * Transfer tokens
90      *
91      * Send `_value` tokens to `_to` from your account
92      *
93      * @param _to The address of the recipient
94      * @param _value the amount to send
95      */
96     function transfer(address _to, uint256 _value) public {
97         _transfer(msg.sender, _to, _value);
98     }
99 
100     /// @notice Create `mintedAmount` tokens and send it to `target`
101     /// @param target Address to receive the tokens
102     /// @param mintedAmount the amount of tokens it will receive
103     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
104         balanceOf[target] += mintedAmount;
105         totalSupply += mintedAmount;
106         emit Transfer(0, this, mintedAmount);
107         emit Transfer(this, target, mintedAmount);
108     }
109 
110     /**
111      * Destroy tokens from account
112      *
113      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
114      *
115      * @param _from the address from where to burn
116      * @param _value the amount of token to burn
117      */
118     function burnFrom(address _from, uint256 _value) onlyOwner public {
119         require(balanceOf[_from] >= _value);
120         balanceOf[_from] -= _value;
121         totalSupply -= _value;
122         emit Burn(_from, _value);
123     }
124 
125     /// @notice Withdraw `amount` to owner
126     /// @param amount amount to be withdrawn
127     function withdraw(uint256 amount) onlyOwner public {
128         require(address(this).balance >= amount);
129         owner.transfer(amount);
130     }
131 
132     /// @notice `Allow | Prevent` `target` from sending & receiving tokens
133     /// @param target Address to be allowed or not
134     /// @param approve either to allow it or not
135     function approveAccount(address target, bool approve) onlyAdmin public {
136         approvedAccount[target] = approve;
137         emit ApprovedAccount(target, approve);
138     }
139 
140     /// @param newBid Price the users can sell to the contract
141     /// @param newAsk Price users can buy from the contract
142     function setPrices(uint256 newBid, uint256 newAsk) onlyAdmin public {
143         bid = newBid;
144         ask = newAsk;
145     }
146 
147     /// fallback payable function
148     function () payable public {
149         buy();
150     }
151     
152     /// @notice Buy tokens from contract by sending ether
153     function buy() payable public {
154         require(ask > 0);
155         uint256 r = msg.value * (10 ** uint256(decimals));
156         require(r > msg.value);
157         _transfer(this, msg.sender, r / ask);
158     }
159 
160     /// @notice Sell `amount` tokens to contract
161     /// @param amount amount of tokens to be sold
162     function sell(uint256 amount) public {
163         require(bid > 0);
164         require(amount * bid >= amount);
165         uint256 e = (amount * bid) / (10 ** uint256(decimals));
166         require(address(this).balance >= e);
167         _transfer(msg.sender, this, amount);
168         msg.sender.transfer(e);					// sends ether to the seller. It's important to do this last to avoid recursion attacks
169     }
170 }