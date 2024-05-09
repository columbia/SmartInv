1 pragma solidity ^0.4.16;
2 contract Fund{
3 
4     uint256 constant private MAX_UINT256 = 2**256 - 1;
5     mapping (address => uint256) public balances;
6     mapping (address => mapping (address => uint256)) public allowed;
7     /*
8     NOTE:
9     The following variables are OPTIONAL vanities. One does not have to include them.
10     They allow one to customise the token contract & in no way influences the core functionality.
11     Some wallets/interfaces might not even bother to look at this information.
12     */
13     uint256 public totalSupply;
14     string public name;                   //fancy name: eg Simon Bucks
15     uint8 public decimals;                //How many decimals to show.
16     string public symbol;                 //An identifier: eg SBX
17      event Transfer(address indexed _from, address indexed _to, uint256 _value); 
18     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
19    
20     function Fund() public {
21         balances[msg.sender] = 1000000000000;               // Give the creator all initial tokens
22         totalSupply = 1000000000000;                        // Update total supply
23         name = "Fund token";                                   // Set the name for display purposes
24         decimals =4;                            // Amount of decimals for display purposes
25         symbol = "Fund";                               // Set the symbol for display purposes
26     }
27 
28     function transfer(address _to, uint256 _value) public returns (bool success) {
29         require(balances[msg.sender] >= _value);
30         balances[msg.sender] -= _value;
31         balances[_to] += _value;
32         Transfer(msg.sender, _to, _value);
33         return true;
34     }
35 
36     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
37         uint256 allowance = allowed[_from][msg.sender];
38         require(balances[_from] >= _value && allowance >= _value);
39         balances[_to] += _value;
40         balances[_from] -= _value;
41         if (allowance < MAX_UINT256) {
42             allowed[_from][msg.sender] -= _value;
43         }
44         Transfer(_from, _to, _value);
45         return true;
46     }
47 
48     function balanceOf(address _owner) public view returns (uint256 balance) {
49         return balances[_owner];
50     }
51 
52     function approve(address _spender, uint256 _value) public returns (bool success) {
53         allowed[msg.sender][_spender] = _value;
54         Approval(msg.sender, _spender, _value);
55         return true;
56     }
57 
58     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
59         return allowed[_owner][_spender];
60     }   
61 }