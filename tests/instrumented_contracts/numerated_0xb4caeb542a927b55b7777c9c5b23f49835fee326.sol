1 pragma solidity ^0.4.16;
2 contract WNCT  {
3     uint256 constant private MAX_UINT256 = 2**256 - 1;
4     mapping (address => uint256) public balances;
5     mapping (address => mapping (address => uint256)) public allowed;
6 
7     uint256 public totalSupply;
8     string public name;                   //fancy name: eg Simon Bucks
9     uint8 public decimals;                //How many decimals to show.
10     string public symbol;                 //An identifier: eg SBX
11     event Transfer(address indexed _from, address indexed _to, uint256 _value); 
12     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
13    
14     function WNCT() public {
15         balances[msg.sender] = 100000000000000;               // Give the creator all initial tokens
16         totalSupply = 100000000000000;                        // Update total supply
17         name = "Wellnewss Chain";                                   // Set the name for display purposes
18         decimals =4;                            // Amount of decimals for display purposes
19         symbol = "WNCT";                               // Set the symbol for display purposes
20     }
21 
22     function transfer(address _to, uint256 _value) public returns (bool success) {
23         require(balances[msg.sender] >= _value);
24         balances[msg.sender] -= _value;
25         balances[_to] += _value;
26         Transfer(msg.sender, _to, _value);
27         return true;
28     }
29 
30     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
31         uint256 allowance = allowed[_from][msg.sender];
32         require(balances[_from] >= _value && allowance >= _value);
33         balances[_to] += _value;
34         balances[_from] -= _value;
35         if (allowance < MAX_UINT256) {
36             allowed[_from][msg.sender] -= _value;
37         }
38         Transfer(_from, _to, _value);
39         return true;
40     }
41 
42     function balanceOf(address _owner) public view returns (uint256 balance) {
43         return balances[_owner];
44     }
45 
46     function approve(address _spender, uint256 _value) public returns (bool success) {
47         allowed[msg.sender][_spender] = _value;
48         Approval(msg.sender, _spender, _value);
49         return true;
50     }
51 
52     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
53         return allowed[_owner][_spender];
54     }   
55 }