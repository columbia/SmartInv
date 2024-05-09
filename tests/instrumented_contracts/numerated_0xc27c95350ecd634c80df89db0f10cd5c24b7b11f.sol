1 pragma solidity ^0.4.19;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
4 
5 contract Ownable {
6   address public owner;
7 
8 
9   /** 
10    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
11    * account.
12    */
13   function Ownable() {
14     owner = msg.sender;
15   }
16 
17 
18   /**
19    * @dev Throws if called by any account other than the owner. 
20    */
21   modifier onlyOwner() {
22     if (msg.sender != owner) {
23       throw;
24     }
25     _;
26   }
27 
28 
29   /**
30    * @dev Allows the current owner to transfer control of the contract to a newOwner.
31    * @param newOwner The address to transfer ownership to. 
32    */
33   function transferOwnership(address newOwner) onlyOwner {
34     if (newOwner != address(0)) {
35       owner = newOwner;
36     }
37   }
38 
39 }
40 
41 contract PixieCoin is Ownable {
42     string public name;
43     string public symbol;
44     uint8 public decimals = 2; 
45     uint256 public totalSupply;
46 
47     mapping (address => uint256) public balanceOf;  // 
48     mapping (address => mapping (address => uint256)) public allowance;
49 
50     event Transfer(address indexed from, address indexed to, uint256 value);
51 
52     event Burn(address indexed from, uint256 value);
53     
54     function multisend(address _tokenAddr, address[] dests, uint256[] values)
55     onlyOwner
56     returns (uint256) {
57         uint256 i= 0;
58         while (i < dests.length) {
59             transfer(dests[i], values[i]);
60         i += 1;
61         }
62         return(i);
63     }
64     
65     function PixieCoin(uint256 initialSupply, string tokenName, string tokenSymbol) public {
66         totalSupply = initialSupply * 10 ** uint256(decimals);
67         balanceOf[msg.sender] = totalSupply;
68         name = tokenName;
69         symbol = tokenSymbol;
70     }
71 
72 
73     function _transfer(address _from, address _to, uint _value) internal {
74         require(_to != 0x0);
75         require(balanceOf[_from] >= _value);
76         require(balanceOf[_to] + _value > balanceOf[_to]);
77         uint previousBalances = balanceOf[_from] + balanceOf[_to];
78         balanceOf[_from] -= _value;
79         balanceOf[_to] += _value;
80         Transfer(_from, _to, _value);
81         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
82     }
83 
84     function transfer(address _to, uint256 _value) public {
85         _transfer(msg.sender, _to, _value);
86     }
87 
88     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
89         require(_value <= allowance[_from][msg.sender]);     // Check allowance
90         allowance[_from][msg.sender] -= _value;
91         _transfer(_from, _to, _value);
92         return true;
93     }
94 
95     function approve(address _spender, uint256 _value) public
96         returns (bool success) {
97         allowance[msg.sender][_spender] = _value;
98         return true;
99     }
100 
101     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
102         tokenRecipient spender = tokenRecipient(_spender);
103         if (approve(_spender, _value)) {
104             spender.receiveApproval(msg.sender, _value, this, _extraData);
105             return true;
106         }
107     }
108 
109 
110 }