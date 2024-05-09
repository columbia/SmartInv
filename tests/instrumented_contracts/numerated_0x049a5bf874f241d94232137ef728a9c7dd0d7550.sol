1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title ERC20Interface
5  * @dev Standart version of ERC20 interface
6  */
7 contract ERC20Interface {
8     uint256 public totalSupply;
9     function balanceOf(address _owner) public view returns (uint256 balance);
10     function transfer(address _to, uint256 _value) public returns (bool success);
11     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
12     function approve(address _spender, uint256 _value) public returns (bool success);
13     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
14     event Transfer(address indexed _from, address indexed _to, uint256 _value);
15     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
16 }
17 
18 /**
19  * @title Ownable
20  * @dev The Ownable contract has an owner address, and provides basic authorization control
21  * functions, this simplifies the implementation of "user permissions".
22  */
23 contract Ownable {
24     address public owner;
25 
26     /**
27      * @dev The Ownable constructor sets the original `owner` 
28      * of the contract to the sender account.
29      */
30     function Ownable() public {
31         owner = msg.sender;
32     }
33 
34     /**
35      * @dev Throws if called by any account other than the current owner
36      */
37     modifier onlyOwner {
38         require(msg.sender == owner);
39         _;
40     }
41 
42     /**
43      * @dev Allows the current owner to transfer control of the contract to a newOwner
44      * @param newOwner The address to transfer ownership to
45      */
46     function transferOwnership(address newOwner) public onlyOwner {
47         require(newOwner != address(0));
48         owner = newOwner;
49     }
50 }
51 
52 /**
53  * @title DataTradingToken
54  * @dev Implemantation of the DataTrading token
55  */
56 contract DataTradingToken is Ownable, ERC20Interface {
57     string public constant symbol = "DTT";
58     string public constant name = "DataTrading Token";
59     uint8 public constant decimals = 18;
60     uint256 private _unmintedTokens = 360000000*uint(10)**decimals;
61     
62     mapping(address => uint256) balances;
63     mapping (address => mapping (address => uint256)) internal allowed;
64     
65     event Approval(address indexed owner, address indexed spender, uint256 value);
66     event Transfer(address indexed from, address indexed to, uint256 value);
67       
68     /**
69      * @dev Gets the balance of the specified address
70      * @param _owner The address to query the the balance of
71      * @return An uint256 representing the amount owned by the passed address
72      */
73     function balanceOf(address _owner) public view returns (uint256 balance) {
74         return balances[_owner];
75     }
76     
77     /**
78      * @dev Transfer token to a specified address
79      * @param _to The address to transfer to
80      * @param _value The amount to be transferred
81      */  
82     function transfer(address _to, uint256 _value) public returns (bool success) {
83         require(_to != address(0));
84         require(balances[msg.sender] >= _value);
85         assert(balances[_to] + _value >= balances[_to]);
86         
87         balances[msg.sender] -= _value;
88         balances[_to] += _value;
89         Transfer(msg.sender, _to, _value);
90         return true;
91     }
92     
93     /**
94      * @dev Transfer tokens from one address to another 
95      * @param _from The address which you want to send tokens from
96      * @param _to The address which you want to transfer to
97      * @param _value The amout of tokens to be transfered
98      */
99     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
100         require(_to != address(0));
101         require(_value <= balances[_from]);
102         require(_value <= allowed[_from][msg.sender]);
103         assert(balances[_to] + _value >= balances[_to]);
104         
105         balances[_from] = balances[_from] - _value;
106         balances[_to] = balances[_to] + _value;
107         allowed[_from][msg.sender] = allowed[_from][msg.sender] - _value;
108         Transfer(_from, _to, _value);
109         return true;
110     }
111 
112     /**
113      * @dev Aprove the passed address to spend the specified amount of tokens on beahlf of msg.sender
114      * @param _spender The address which will spend the funds
115      * @param _value The amount of tokens to be spent
116      */
117     function approve(address _spender, uint256 _value) public returns (bool success) {
118         allowed[msg.sender][_spender] = _value;
119         Approval(msg.sender, _spender, _value);
120         return true;
121     }
122     
123     /**
124      * @dev Function to check the amount of tokens than an owner allowed to a spender
125      * @param _owner The address which owns the funds
126      * @param _spender The address which will spend the funds
127      * @return A uint specifing the amount of tokens still avaible for the spender
128      */
129     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
130         return allowed[_owner][_spender];
131     }
132 
133     /**
134      * @dev Mint DataTrading tokens. No more than 360,000,000 DTT can be minted
135      * @param _target The address to which new tokens will be minted
136      * @param _mintedAmount The amout of tokens to be minted
137      */    
138     function mintTokens(address _target, uint256 _mintedAmount) public onlyOwner returns (bool success){
139         require(_mintedAmount <= _unmintedTokens);
140         balances[_target] += _mintedAmount;
141         _unmintedTokens -= _mintedAmount;
142         totalSupply += _mintedAmount;
143         return true;
144     }
145     
146     /**
147      * @dev Mint DataTrading tokens and aproves the passed address to spend the minted amount of tokens
148      * No more than 360,000,000 DTT can be minted
149      * @param _target The address to which new tokens will be minted
150      * @param _mintedAmount The amout of tokens to be minted
151      * @param _spender The address which will spend minted funds
152      */ 
153     function mintTokensWithApproval(address _target, uint256 _mintedAmount, address _spender) public onlyOwner returns (bool success){
154         require(_mintedAmount <= _unmintedTokens);
155         balances[_target] += _mintedAmount;
156         _unmintedTokens -= _mintedAmount;
157         totalSupply += _mintedAmount;
158         allowed[_target][_spender] += _mintedAmount;
159         return true;
160     }
161     
162     /**
163      * @dev Decrease amount of DataTrading tokens that can be minted
164      * @param _burnedAmount The amout of unminted tokens to be burned
165      */ 
166     function burnUnmintedTokens(uint256 _burnedAmount) public onlyOwner returns (bool success){
167         require(_burnedAmount <= _unmintedTokens);
168         _unmintedTokens -= _burnedAmount;
169         return true;
170     }
171 }