1 pragma solidity ^0.4.21;
2 
3 
4 contract EIP20Interface {
5  
6     /// total amount of tokens
7     uint256 public totalSupply;
8 
9 
10     function balanceOf(address _owner) public view returns (uint256 balance);
11 
12 
13     function transfer(address _to, uint256 _value) public returns (bool success);
14 
15 
16     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
17 
18     function approve(address _spender, uint256 _value) public returns (bool success);
19 
20 
21     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
22 
23     event Transfer(address indexed _from, address indexed _to, uint256 _value);
24     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
25 }
26 
27 contract theEBCC is EIP20Interface {
28 
29     uint256 constant private MAX_UINT256 = 2**256 - 1;
30     mapping (address => uint256) public balances;
31     mapping (address => mapping (address => uint256)) public allowed;
32     /*
33     NOTE:
34     The following variables are OPTIONAL vanities. One does not have to include them.
35     They allow one to customise the token contract & in no way influences the core functionality.
36     Some wallets/interfaces might not even bother to look at this information.
37     */
38     string public name;                   //fancy name: eg Simon Bucks
39     uint8 public decimals;                //How many decimals to show.
40     string public symbol;                 //An identifier: eg SBX
41 
42     function theEBCC(
43         uint256 _initialAmount,
44         string _tokenName,
45         uint8 _decimalUnits,
46         string _tokenSymbol
47     ) public {
48         balances[msg.sender] = _initialAmount;               // Give the creator all initial tokens
49         totalSupply = _initialAmount;                        // Update total supply
50         name = _tokenName;                                   // Set the name for display purposes
51         decimals = _decimalUnits;                            // Amount of decimals for display purposes
52         symbol = _tokenSymbol;                               // Set the symbol for display purposes
53     }
54 
55     function transfer(address _to, uint256 _value) public returns (bool success) {
56         require(balances[msg.sender] >= _value);
57         balances[msg.sender] -= _value;
58         balances[_to] += _value;
59         emit Transfer(msg.sender, _to, _value); //solhint-disable-line indent, no-unused-vars
60         return true;
61     }
62 
63     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
64         uint256 allowance = allowed[_from][msg.sender];
65         require(balances[_from] >= _value && allowance >= _value);
66         balances[_to] += _value;
67         balances[_from] -= _value;
68         if (allowance < MAX_UINT256) {
69             allowed[_from][msg.sender] -= _value;
70         }
71         emit Transfer(_from, _to, _value); //solhint-disable-line indent, no-unused-vars
72         return true;
73     }
74 
75     function balanceOf(address _owner) public view returns (uint256 balance) {
76         return balances[_owner];
77     }
78 
79     function approve(address _spender, uint256 _value) public returns (bool success) {
80         allowed[msg.sender][_spender] = _value;
81         emit Approval(msg.sender, _spender, _value); //solhint-disable-line indent, no-unused-vars
82         return true;
83     }
84 
85     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
86         return allowed[_owner][_spender];
87     }
88 }