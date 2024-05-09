1 pragma solidity ^0.4.16;
2 
3 contract SuperTicketCoin {
4     string public name;
5     string public symbol;
6     uint8 public decimals = 18;
7     uint256 public totalSupply;
8 
9     mapping (address => uint256) public balanceOf;
10     mapping (address => mapping (address => uint256)) public allowance;
11 
12     event Transfer(address indexed from, address indexed to, uint256 value);
13     
14     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
15 
16     event Burn(address indexed from, uint256 value);
17 
18     function SuperTicketCoin(
19         uint256 initialSupply,
20         string tokenName,
21         string tokenSymbol
22     ) public {
23         totalSupply = initialSupply * 10 ** uint256(decimals);
24         balanceOf[msg.sender] = totalSupply;
25         name = tokenName;
26         symbol = tokenSymbol;
27     }
28 
29     function _transfer(address _from, address _to, uint _value) internal {
30         require(_to != 0x0);
31         require(balanceOf[_from] >= _value);
32         require(balanceOf[_to] + _value >= balanceOf[_to]);
33         uint previousBalances = balanceOf[_from] + balanceOf[_to];
34         balanceOf[_from] -= _value;
35         balanceOf[_to] += _value;
36         emit Transfer(_from, _to, _value);
37         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
38     }
39 
40     function transfer(address _to, uint256 _value) public returns (bool success) {
41         _transfer(msg.sender, _to, _value);
42         return true;
43     }
44 
45     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
46         require(_value <= allowance[_from][msg.sender]);
47         allowance[_from][msg.sender] -= _value;
48         _transfer(_from, _to, _value);
49         return true;
50     }
51 
52     function burn(uint256 _value) public returns (bool success) {
53         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
54         balanceOf[msg.sender] -= _value;            // Subtract from the sender
55         totalSupply -= _value;                      // Updates totalSupply
56         emit Burn(msg.sender, _value);
57         return true;
58     }
59 
60     function burnFrom(address _from, uint256 _value) public returns (bool success) {
61         require(balanceOf[_from] >= _value);
62         require(_value <= allowance[_from][msg.sender]);
63         balanceOf[_from] -= _value;
64         allowance[_from][msg.sender] -= _value;
65         totalSupply -= _value;
66         emit Burn(_from, _value);
67         return true;
68     }
69 }