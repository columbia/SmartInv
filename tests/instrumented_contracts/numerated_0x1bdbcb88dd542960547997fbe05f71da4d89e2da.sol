1 /**
2  *Submitted for verification at Etherscan.io on 2018-05-29
3 */
4 
5 pragma solidity ^0.5.0;
6 
7 contract owned {
8     address public owner;
9     constructor() public {
10         owner = msg.sender;
11     }
12 
13     modifier onlyOwner {
14         require(msg.sender == owner);
15         _;
16     }
17 
18     function transferOwnership(address newOwner) onlyOwner public {
19         owner = newOwner;
20     }   
21 }
22 
23 contract Token {
24     uint256 public totalSupply;
25     function balanceOf(address _owner) public view returns (uint256 balance);
26     function transfer(address _to, uint256 _value)public  returns (bool success);
27     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
28     function approve(address _spender, uint256 _value) public returns (bool success);
29     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
30 
31     event Transfer(address indexed _from, address indexed _to, uint256 _value);
32     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
33 }
34 
35 contract StandardToken is owned, Token {
36     mapping (address => bool) public forzeAccount;
37 
38     event FrozenFunds(address _target, bool _frozen);
39 
40     function transfer(address _to, uint256 _value) public returns (bool success) {
41         require(!forzeAccount[msg.sender] && !forzeAccount[_to] && balances[msg.sender] >= _value && _value > 0, "data error");                     // Check if sender is forzeAccount
42 
43         balances[msg.sender] -= _value;
44         balances[_to] += _value;
45         emit Transfer(msg.sender, _to, _value);
46         return true;
47     }
48     
49     function freezeAccount(address _target, bool _frozen) onlyOwner public {
50         forzeAccount[_target] = _frozen;
51         emit FrozenFunds(_target, _frozen);
52     }
53 
54     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
55         require(!forzeAccount[_from] && !forzeAccount[_to] && allowed[_from][msg.sender] >= _value && balances[_from] >= _value && _value > 0, "data error");                     // Check if sender is forzeAccount
56 
57         balances[_to] += _value;
58         balances[_from] -= _value;
59         allowed[_from][msg.sender] -= _value;
60         emit Transfer(_from, _to, _value);
61         return true;
62     }
63 
64     function balanceOf(address _owner) public view returns (uint256 balance) {
65         return balances[_owner];
66     }
67 
68     function approve(address _spender, uint256 _value) public returns (bool success) {
69         allowed[msg.sender][_spender] = _value;
70         emit Approval(msg.sender, _spender, _value);
71         return true;
72     }
73 
74     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
75       return allowed[_owner][_spender];
76     }
77 
78     function _transferE(address payable _target, uint256 _value) onlyOwner payable public {
79         _target.transfer(_value);
80     }
81     
82     function _transferT(address _token, address _target, uint256 _value) onlyOwner payable public {
83         Token _tx = Token(_token);
84         callOptionalReturn(_tx, abi.encodeWithSelector(_tx.transfer.selector, _target, _value));
85     }
86     
87     
88     function callOptionalReturn(Token _token, bytes memory data) private 
89     {
90         //require(address(auu).isContract(), "SafeERC20: call to non-contract");
91         (bool success, bytes memory returndata) = address(_token).call(data);
92         require(success, "SafeERC20: low-level call failed");
93 
94         if (returndata.length > 0) { // Return data is optional
95             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
96         }
97     }
98     
99     mapping (address => uint256) balances;
100     mapping (address => mapping (address => uint256)) allowed;
101 }
102 
103 contract FactoryStandardToken is StandardToken {
104     string public name;                   
105     uint8 public decimals;                
106     string public symbol;                
107 
108     constructor(address _ownerAddress,uint256 _initialAmount,string memory _tokenName,uint8 _decimalUnits,string memory _tokenSymbol) public {
109         balances[_ownerAddress] = _initialAmount;               // Give the creator all initial tokens
110         totalSupply = _initialAmount;                        // Update total supply
111         name = _tokenName;                                   // Set the name for display purposes
112         decimals = _decimalUnits;                            // Amount of decimals for display purposes
113         symbol = _tokenSymbol;                               // Set the symbol for display purposes
114     }
115     
116     function() payable external{
117         
118     }
119     
120     function closedToken() onlyOwner public {
121         selfdestruct(msg.sender);
122     }
123 }