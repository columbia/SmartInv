1 pragma solidity ^0.4.25;
2 
3 contract owned {
4     address public owner;
5 
6     constructor() public {
7         owner = msg.sender;
8     }
9 
10     modifier onlyOwner {
11         require(msg.sender == owner);
12         _;
13     }
14 
15     function transferOwnership(address newOwner) onlyOwner public {
16         owner = newOwner;
17     }
18 } 
19 
20 contract Infireum  is owned {
21     string public name;
22     string public symbol;
23     uint8 public decimals = 8; 
24     uint256 public totalSupply;
25     mapping (address => bool) public frozenAccount;
26     
27     /* This generates a public event on the blockchain that will notify clients */
28     event FrozenFunds(address target, bool frozen);
29 
30     mapping (address => uint256) public balanceOf;
31     mapping (address => mapping (address => uint256)) public allowance;
32 
33     event Transfer(address indexed from, address indexed to, uint256 value);
34     event Burn(address indexed from, uint256 value);
35 
36 
37     constructor() public {
38         totalSupply = 10000000000 * 10 ** uint256(decimals); 
39         balanceOf[msg.sender] = totalSupply;              
40         name = "Infireum";                                 
41         symbol = "IFR";                            
42     }
43 
44     function _transfer(address _from, address _to, uint _value) internal {
45   
46         require(_to != 0x0);
47         require(balanceOf[_from] >= _value);
48         require(balanceOf[_to] + _value > balanceOf[_to]);
49         require(!frozenAccount[_from]);                     
50         require(!frozenAccount[_to]);  
51         
52         uint previousBalances = balanceOf[_from] + balanceOf[_to];
53         // Subtract from the sender
54         balanceOf[_from] -= _value;
55         // Add the same to the recipient
56         balanceOf[_to] += _value;
57         emit Transfer(_from, _to, _value);
58 
59         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
60     }
61 
62     function transfer(address _to, uint256 _value) public {
63         _transfer(msg.sender, _to, _value);
64     }
65 
66 
67     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
68         require(_value <= allowance[_from][msg.sender]);     // Check allowance
69         allowance[_from][msg.sender] -= _value;
70         _transfer(_from, _to, _value);
71         return true;
72     }
73 
74     function approve(address _spender, uint256 _value) public
75         returns (bool success) {
76         allowance[msg.sender][_spender] = _value;
77         return true;
78     }
79     
80     function freezeAccount(address target, bool freeze) onlyOwner public {
81             frozenAccount[target] = freeze;
82             emit FrozenFunds(target, freeze);
83     }
84   
85 }