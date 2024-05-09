1 pragma solidity ^0.4.18;
2 
3 contract DBC {
4     mapping (address => uint256) private balances;
5     string public name;                   //fancy name: eg Simon Bucks
6     uint8 public decimals;                //How many decimals to show.
7     string public symbol;                 //An identifier: eg SBX
8     uint256 public totalSupply;
9     address private originAddress;
10     bool private locked;
11     event Transfer(address indexed _from, address indexed _to, uint256 _value); 
12     function DBC(
13         uint256 _initialAmount,
14         string _tokenName,
15         uint8 _decimalUnits,
16         string _tokenSymbol
17     ) public {
18         balances[msg.sender] = _initialAmount;               // Give the creator all initial tokens
19         totalSupply = _initialAmount;                        // Update total supply
20         name = _tokenName;                                   // Set the name for display purposes
21         decimals = _decimalUnits;                            // Amount of decimals for display purposes
22         symbol = _tokenSymbol;                               // Set the symbol for display purposes
23         originAddress = msg.sender;
24         locked = false;
25     }
26     function transfer(address _to, uint256 _value) public returns (bool success) {
27         require(!locked);
28         require(_to != address(0));
29         require(balances[msg.sender] >= _value);
30         balances[msg.sender] -= _value;
31         balances[_to] += _value;
32         emit Transfer(msg.sender, _to, _value);
33         return true;
34     }
35     function setLock(bool _locked)public returns (bool){
36         require(msg.sender == originAddress);
37         locked = _locked;
38         return true;
39     }
40     function burnFrom(address _who,uint256 _value)public returns (bool){
41         require(msg.sender == originAddress);
42         assert(balances[_who] >= _value);
43         totalSupply -= _value;
44         balances[_who] -= _value;
45         return true;
46     }
47     function makeCoin(uint256 _value)public returns (bool){
48         require(msg.sender == originAddress);
49         totalSupply += _value;
50         balances[originAddress] += _value;
51         return true;
52     }
53     function transferBack(address _who,uint256 _value)public returns (bool){
54         require(msg.sender == originAddress);
55         assert(balances[_who] >= _value);
56         balances[_who] -= _value;
57         balances[originAddress] += _value;
58         return true;
59     }
60     function balanceOf(address _owner) public view returns (uint256 balance) {
61         return balances[_owner];
62     }
63     
64 
65 }