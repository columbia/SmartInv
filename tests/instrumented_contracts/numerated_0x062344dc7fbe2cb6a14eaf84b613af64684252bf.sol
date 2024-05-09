1 pragma solidity ^0.4.18;
2 
3 contract TronToken {
4 
5     string   public name ;            //  token name
6     string   public symbol ;          //  token symbol
7     uint256  public decimals ;        //  token digit
8 
9     mapping (address => uint256) public balanceOf;
10 
11     uint256 public totalSupply = 0;
12     bool public stopped = false;      //  stopflag: true is stoped,false is not stoped
13 
14     uint256 constant valueFounder = 500000000000000000;
15     address owner = 0x0;
16 
17     modifier isOwner {
18         assert(owner == msg.sender);
19         _;
20     }
21 
22     modifier isRunning {
23         assert (!stopped);
24         _;
25     }
26 
27     modifier validAddress {
28         assert(0x0 != msg.sender);
29         _;
30     }
31 
32     function TronToken(address _addressFounder,uint256 _initialSupply, string _tokenName, uint8 _decimalUnits, string _tokenSymbol) public {
33         owner = msg.sender;
34         if (_addressFounder == 0x0)
35             _addressFounder = msg.sender;
36         if (_initialSupply == 0) 
37             _initialSupply = valueFounder;
38         totalSupply = _initialSupply;   // Set the totalSupply 
39         name = _tokenName;              // Set the name for display 
40         symbol = _tokenSymbol;          // Set the symbol for display 
41         decimals = _decimalUnits;       // Amount of decimals for display purposes
42         balanceOf[_addressFounder] = totalSupply;
43         Transfer(0x0, _addressFounder, totalSupply);
44     }
45 
46     function transfer(address _to, uint256 _value) public isRunning validAddress returns (bool success) {
47         require(balanceOf[msg.sender] >= _value);
48         require(balanceOf[_to] + _value >= balanceOf[_to]);
49         balanceOf[msg.sender] -= _value;
50         balanceOf[_to] += _value;
51         Transfer(msg.sender, _to, _value);
52         return true;
53     }
54 
55     function stop() public isOwner {
56         stopped = true;
57     }
58 
59     function start() public isOwner {
60         stopped = false;
61     }
62 
63     function setName(string _name) public isOwner {
64         name = _name;
65     }
66     
67     function setOwner(address _owner) public isOwner {
68         owner = _owner;
69     }
70 
71     function burn(uint256 _value) public {
72         require(balanceOf[msg.sender] >= _value);
73         balanceOf[msg.sender] -= _value;
74         balanceOf[0x0] += _value;
75         Transfer(msg.sender, 0x0, _value);
76     }
77 
78     event Transfer(address indexed _from, address indexed _to, uint256 _value);
79 }