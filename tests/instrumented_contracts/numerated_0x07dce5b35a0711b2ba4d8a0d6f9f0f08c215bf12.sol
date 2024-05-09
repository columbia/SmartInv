1 pragma solidity >=0.5.0 <0.6.0;
2 
3 contract MMRRCToken {
4     string public name = "Make Me Really Rich Coin";
5     string public symbol = "MMRRC";
6     string public standard = "FromMeToYou v1.0";
7 
8     uint256 public tSupply;
9 
10     event Transfer(
11         address indexed _from,
12         address indexed _to,
13         uint256 _value
14     );
15 
16     event Approval(
17         address indexed _owner,
18         address indexed _spender,
19         uint256 _value
20     );
21 
22     mapping(address => uint256) balances;
23     mapping(address => mapping(address => uint256)) public allowance;
24 
25     constructor (uint256 _initialSupply) public {
26         balances[msg.sender] = _initialSupply;
27         tSupply = _initialSupply;
28         
29     }
30 
31     function totalSupply() public view returns (uint256) {
32         return tSupply;
33     }
34 
35     function balanceOf(address tokenOwner) public view returns (uint256 balance) {
36         return balances[tokenOwner];
37     }
38 
39     function transfer(address _to, uint256 _value) public returns (bool success) {
40         
41         require(balances[msg.sender] >= _value, "Insufficient Balance."); 
42         
43         balances[msg.sender] -= _value;
44         balances[_to] += _value;
45 
46         emit Transfer(msg.sender, _to, _value);
47 
48         return true;
49     }
50 
51     function approve(address _spender, uint256 _value) public returns (bool success) {
52         allowance[msg.sender][_spender] = _value;
53 
54         emit Approval(msg.sender, _spender, _value);
55         return true;
56     }
57 
58     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
59         require(_value <= balances[_from], "Not enough tokens for transfer");
60         require(_value <= allowance[_from][msg.sender], "Exceeds allowance");
61         balances[_from] -= _value;
62         balances[_to] += _value;
63 
64         allowance[_from][msg.sender] -= _value;
65 
66         emit Transfer(_from, _to, _value);
67         return true;
68     }
69 }