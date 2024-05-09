1 pragma solidity ^0.4.25;
2 contract MultiVACToken {
3     string public name = "MultiVAC";      //  token name
4     string public symbol = "MTV";           //  token symbol
5     uint256 public decimals = 18;            //  token digit
6     mapping (address => uint256) public balanceOf;
7     mapping (address => mapping (address => uint256)) public allowance;
8     uint256 public totalSupply = 0;
9     bool public stopped = false;
10     uint256 constant initSupply = 10**10;
11     address owner = address(0);
12     modifier isOwner {
13         require(owner == msg.sender);
14         _;
15     }
16     modifier isRunning {
17         require(!stopped);
18         _;
19     }
20     modifier validAddress {
21         require(address(0) != msg.sender);
22         _;
23     }
24     constructor() public {
25         owner = msg.sender;
26         totalSupply = initSupply * (10 ** decimals);
27         balanceOf[msg.sender] = totalSupply;
28         emit Transfer(address(0), msg.sender, totalSupply);
29     }
30     function transfer(address _to, uint256 _value) public isRunning validAddress returns (bool success) {
31         require(_to != address(0));
32         require(balanceOf[msg.sender] >= _value);
33         require(balanceOf[_to] + _value >= balanceOf[_to]);
34         balanceOf[msg.sender] -= _value;
35         balanceOf[_to] += _value;
36         emit Transfer(msg.sender, _to, _value);
37         return true;
38     }
39     function transferFrom(address _from, address _to, uint256 _value) public isRunning validAddress returns (bool success) {
40         require(_to != address(0));
41         require(balanceOf[_from] >= _value);
42         require(balanceOf[_to] + _value >= balanceOf[_to]);
43         require(allowance[_from][msg.sender] >= _value);
44         balanceOf[_to] += _value;
45         balanceOf[_from] -= _value;
46         allowance[_from][msg.sender] -= _value;
47         emit Transfer(_from, _to, _value);
48         return true;
49     }
50     function approve(address _spender, uint256 _value) public isRunning validAddress returns (bool success) {
51         require(_value == 0 || allowance[msg.sender][_spender] == 0);
52         allowance[msg.sender][_spender] = _value;
53         emit Approval(msg.sender, _spender, _value);
54         return true;
55     }
56     function stop() public isOwner {
57         stopped = true;
58     }
59     function start() public isOwner {
60         stopped = false;
61     }
62     function setName(string _name) public isOwner {
63         name = _name;
64     }
65     function burn(uint256 _value) public isRunning {
66         require(balanceOf[msg.sender] >= _value);
67         balanceOf[msg.sender] -= _value;
68         balanceOf[address(0)] += _value;
69         emit Transfer(msg.sender, address(0), _value);
70     }
71     function () public payable{ 
72         revert(); 
73     }
74     event Transfer(address indexed _from, address indexed _to, uint256 _value);
75     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
76 }