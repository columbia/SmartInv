1 pragma solidity ^0.5.2;
2 /*
3         YFIB is the abbreviation of YFIBio.
4         YFIB's success is due to the core technology from YFI.
5         The development core team comes from the United States, China, and South Korea.
6         The YFI technology is independently forked and upgraded to a cluster interactive intelligent aggregator,
7         which aggregates multiple platforms Agreement to realize the interaction of assets on different decentralized liquidity platforms.
8         */
9 contract ERC20Interface {
10   string public name;
11   string public symbol;
12   uint8 public decimals;
13   uint public totalSupply;
14   function transfer(address _to, uint256 _value) public returns (bool success);
15   function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
16   function approve(address _spender, uint256 _value) public returns (bool success);
17   function allowance(address _owner, address _spender) public view returns (uint256 remaining);
18   event Transfer(address indexed _from, address indexed _to, uint256 _value);
19   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
20 }
21 contract YFIB_contract is ERC20Interface {
22   mapping (address => uint256) public balanceOf;
23   mapping (address => mapping (address => uint256) ) internal allowed;
24   constructor() public {
25     name = "yfi.bio";
26     symbol = "YFIB";
27     decimals = 18;
28     // 
29      totalSupply = 90000* (10 ** 18);
30     balanceOf[msg.sender] = totalSupply;
31   }
32   function transfer(address _to, uint256 _value) public returns (bool success){
33     require(_to != address(0));
34     require(balanceOf[msg.sender] >= _value);
35     require(balanceOf[_to] + _value >= balanceOf[_to]);
36     balanceOf[msg.sender] -= _value;
37     balanceOf[_to] += _value;
38     emit Transfer(msg.sender, _to, _value);
39     success = true;
40   }
41   function transferFrom(address _from, address _to, uint256 _value) public returns (bool success){
42     require(_to != address(0));
43     require(balanceOf[_from] >= _value);
44     require(allowed[_from][msg.sender]  >= _value);
45     require(balanceOf[_to] + _value >= balanceOf[_to]);
46     balanceOf[_from] -= _value;
47     balanceOf[_to] += _value;
48     allowed[_from][msg.sender] -= _value;
49     emit Transfer(_from, _to, _value);
50     success = true;
51   }
52   function approve(address _spender, uint256 _value) public returns (bool success){
53       require((_value == 0)||(allowed[msg.sender][_spender] == 0));
54       allowed[msg.sender][_spender] = _value;
55       emit Approval(msg.sender, _spender, _value);
56       success = true;
57   }
58   function allowance(address _owner, address _spender) public view returns (uint256 remaining){
59     return allowed[_owner][_spender];
60   }
61 }