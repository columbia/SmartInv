1 contract PLCCToken {
2 
3     string public name = "Picture Library Copyright Coin";          //  token name
4     string public symbol = "PLCC";           //  token symbol
5     uint256 public decimals = 8;            //  token digit
6 
7     mapping (address => uint256) public balanceOf;
8     mapping (address => mapping (address => uint256)) public allowance;
9 
10     uint256 public totalSupply = 0;
11 
12     uint256 constant valueFounder = 5000000000000000000;
13 
14 
15     modifier validAddress {
16         assert(0x0 != msg.sender);
17         _;
18     }
19 
20     function PLCCToken() {
21         totalSupply = valueFounder;
22         balanceOf[msg.sender] = valueFounder;
23         Transfer(0x0, msg.sender, valueFounder);
24     }
25 
26     function transfer(address _to, uint256 _value) validAddress returns (bool success) {
27         require(balanceOf[msg.sender] >= _value);
28         require(balanceOf[_to] + _value >= balanceOf[_to]);
29         balanceOf[msg.sender] -= _value;
30         balanceOf[_to] += _value;
31         Transfer(msg.sender, _to, _value);
32         return true;
33     }
34 
35     function transferFrom(address _from, address _to, uint256 _value) validAddress returns (bool success) {
36         require(balanceOf[_from] >= _value);
37         require(balanceOf[_to] + _value >= balanceOf[_to]);
38         require(allowance[_from][msg.sender] >= _value);
39         balanceOf[_to] += _value;
40         balanceOf[_from] -= _value;
41         allowance[_from][msg.sender] -= _value;
42         Transfer(_from, _to, _value);
43         return true;
44     }
45 
46     function approve(address _spender, uint256 _value) validAddress returns (bool success) {
47         require(_value == 0 || allowance[msg.sender][_spender] == 0);
48         allowance[msg.sender][_spender] = _value;
49         Approval(msg.sender, _spender, _value);
50         return true;
51     }
52 
53     function burn(uint256 _value) {
54         require(balanceOf[msg.sender] >= _value);
55         require(totalSupply >= _value);
56         balanceOf[msg.sender] -= _value;
57         totalSupply -= _value;
58         Burn(msg.sender, _value);
59     }
60     
61     event Transfer(address indexed _from, address indexed _to, uint256 _value);
62     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
63     event Burn(address indexed burner, uint256 value);
64 }