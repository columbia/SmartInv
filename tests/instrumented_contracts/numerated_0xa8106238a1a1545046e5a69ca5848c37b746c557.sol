1 pragma solidity 0.4.24;
2 
3 contract AbcdEfg {
4 
5   mapping (address => uint256) private balances;
6   mapping (address => uint256) private marked;
7   uint256 private totalSupply_ = 1000;
8   uint256 private markId = 0;
9 
10   mapping (uint256 => bytes) public marks;
11   string public name = "abcdEfg";
12   string public symbol = "a2g";
13   uint8 public decimals = 0;
14   string public memo = "Fit in the words here!Fit in the words here!Fit in the words here!Fit in the words here!";
15 
16   event Transfer(
17     address indexed from,
18     address indexed to,
19     uint256 value
20   );
21   
22   constructor() public {
23     balances[msg.sender] = totalSupply_;
24   } 
25   
26   function () public {
27       mark();
28   }
29 
30   function mark() internal {
31     markId ++;
32     marked[msg.sender] ++;
33     marks[markId] = abi.encodePacked(msg.sender, msg.data);
34   }
35 
36   function totalSupply() public view returns (uint256) {
37     return totalSupply_;
38   }
39 
40   function balanceOf(address _owner) public view returns (uint256) {
41     return balances[_owner];
42   }
43 
44   function transfer(address _to, uint256 _value) public returns (bool) {
45     require(_value + marked[msg.sender] <= balances[msg.sender]);
46     require(_to != address(0));
47 
48     balances[msg.sender] = balances[msg.sender] - _value;
49     balances[_to] = balances[_to] + _value;
50     emit Transfer(msg.sender, _to, _value);
51     return true;
52   }
53 
54 }