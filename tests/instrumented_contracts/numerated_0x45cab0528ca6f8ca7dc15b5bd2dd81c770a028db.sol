1 pragma solidity ^0.4.24;
2 contract EIP20Interface {
3     uint256 public totalSupply;
4     function balanceOf(address _owner) public view returns (uint256 balance);
5     function transfer(address _to, uint256 _value) public returns (bool success);
6     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
7     function approve(address _spender, uint256 _value) public returns (bool success);
8     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
9     event Transfer(address indexed _from, address indexed _to, uint256 _value);
10     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
11 }
12 
13 contract EIP20 is EIP20Interface {
14     uint256 constant private MAX_UINT256 = 2**256 - 1;
15     mapping (address => uint256) public balances;
16     mapping (address => mapping (address => uint256)) public allowed;
17     string public name;                   //fancy name: eg Simon Bucks
18     uint8 public decimals;                //How many decimals to show.
19     string public symbol;                 //An identifier: eg SBX
20 
21     function EIP20(
22         uint256 _initialAmount,
23         string _tokenName,
24         uint8 _decimalUnits,
25         string _tokenSymbol
26     ) public {
27         balances[msg.sender] = _initialAmount;               // Give the creator all initial tokens
28         totalSupply = _initialAmount;                        // Update total supply
29         name = _tokenName;                                   // Set the name for display purposes
30         decimals = _decimalUnits;                            // Amount of decimals for display purposes
31         symbol = _tokenSymbol;                               // Set the symbol for display purposes
32     }
33 
34     function transfer(address _to, uint256 _value) public returns (bool success) {
35         require(balances[msg.sender] >= _value);
36         balances[msg.sender] -= _value;
37         balances[_to] += _value;
38         emit Transfer(msg.sender, _to, _value); //solhint-disable-line indent, no-unused-vars
39         return true;
40     }
41 
42     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
43         uint256 allowance = allowed[_from][msg.sender];
44         require(balances[_from] >= _value && allowance >= _value);
45         balances[_to] += _value;
46         balances[_from] -= _value;
47         if (allowance < MAX_UINT256) {
48             allowed[_from][msg.sender] -= _value;
49         }
50         emit Transfer(_from, _to, _value); //solhint-disable-line indent, no-unused-vars
51         return true;
52     }
53 
54     function balanceOf(address _owner) public view returns (uint256 balance) {
55         return balances[_owner];
56     }
57 
58     function approve(address _spender, uint256 _value) public returns (bool success) {
59         allowed[msg.sender][_spender] = _value;
60         emit Approval(msg.sender, _spender, _value); //solhint-disable-line indent, no-unused-vars
61         return true;
62     }
63 
64     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
65         return allowed[_owner][_spender];
66     }
67 }