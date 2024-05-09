1 pragma solidity 0.4.24;
2 
3 contract AbcdEfg {
4   mapping (uint256 => bytes) public marks;
5   string public constant name = "abcdEfg";
6   string public constant symbol = "a2g";
7   uint8 public constant decimals = 0;
8   string public constant memo = "Fit in the words here!Fit in the words here!Fit in the words here!Fit in the words here!";
9   
10   mapping (address => uint256) private balances;
11   mapping (address => uint256) private marked;
12   uint256 private totalSupply_ = 1000;
13   uint256 private markId = 0;
14 
15   event Transfer(
16     address indexed from,
17     address indexed to,
18     uint256 value
19   );
20   
21   constructor() public {
22     balances[msg.sender] = totalSupply_;
23   } 
24   
25   function () public {
26       mark();
27   }
28 
29   function mark() internal {
30     markId ++;
31     marked[msg.sender] ++;
32     marks[markId] = abi.encodePacked(msg.sender, msg.data);
33   }
34 
35   function totalSupply() public view returns (uint256) {
36     return totalSupply_;
37   }
38 
39   function balanceOf(address _owner) public view returns (uint256) {
40     return balances[_owner];
41   }
42 
43   function transfer(address _to, uint256 _value) public returns (bool) {
44     require(_value + marked[msg.sender] <= balances[msg.sender]);
45     require(_to != address(0));
46 
47     balances[msg.sender] = balances[msg.sender] - _value;
48     balances[_to] = balances[_to] + _value;
49     emit Transfer(msg.sender, _to, _value);
50     return true;
51   }
52 
53 }