1 pragma solidity ^0.4.24;
2 
3 contract owned {
4     address public owner;
5 
6     function owned() public {
7         owner = msg.sender;
8     }
9 
10     modifier onlyOwner {
11         require(msg.sender == owner);
12         _;
13     }
14 
15 }
16 
17 
18 contract TokenERC20 {
19     string public name;
20     string public symbol;
21     uint8 public decimals = 18;
22     uint256 public totalSupply;
23 
24     mapping (address => uint256) public balanceOf;
25 
26     event Transfer(address indexed from, address indexed to, uint256 value);
27 
28     function TokenERC20(
29         uint256 initialSupply,
30         string tokenName,
31         string tokenSymbol
32     ) public {
33         totalSupply = initialSupply * 10 ** uint256(decimals);  
34         balanceOf[msg.sender] = totalSupply;               
35         name = tokenName;                                   
36         symbol = tokenSymbol;                               
37     }
38 
39     function _transfer(address _from, address _to, uint _value) internal {
40         require(_to != 0x0);
41         require(balanceOf[_from] >= _value);
42         require(balanceOf[_to] + _value > balanceOf[_to]);
43         uint previousBalances = balanceOf[_from] + balanceOf[_to];
44         balanceOf[_from] -= _value;
45         balanceOf[_to] += _value;
46         Transfer(_from, _to, _value);
47         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
48     }
49 
50 
51     function transfer(address _to, uint256 _value) public {
52         _transfer(msg.sender, _to, _value);
53     }
54 
55 
56 }
57 
58 
59 contract StudyCoin is owned, TokenERC20 {
60 
61     function StudyCoin(
62     ) TokenERC20(2000000000, "study Coin", "STUDY") public {}
63 
64     function _transfer(address _from, address _to, uint _value) internal {
65         require (_to != 0x0);                              
66         require (balanceOf[_from] >= _value);               
67         require (balanceOf[_to] + _value > balanceOf[_to]); 
68         balanceOf[_from] -= _value;                         
69         balanceOf[_to] += _value;                          
70         Transfer(_from, _to, _value);
71     }
72 
73 }