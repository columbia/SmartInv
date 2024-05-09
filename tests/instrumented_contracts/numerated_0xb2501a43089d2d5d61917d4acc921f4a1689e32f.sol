1 pragma solidity 0.4.24;
2 
3 contract AbcdEfg {
4   mapping (uint256 => Mark) public marks;
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
21   struct Mark {
22     address author;
23     bytes content;
24   }
25 
26   constructor() public {
27     balances[msg.sender] = totalSupply_;
28   } 
29   
30   function () public {
31       mark();
32   }
33 
34   function mark() internal {
35     require(1 + marked[msg.sender] <= balances[msg.sender]);
36     markId ++;
37     marked[msg.sender] ++;
38     Mark memory temp;
39     temp.author = msg.sender;
40     temp.content = msg.data;
41     marks[markId] = temp;
42   }
43   
44   function totalSupply() public view returns (uint256) {
45     return totalSupply_;
46   }
47 
48   function balanceOf(address _owner) public view returns (uint256) {
49     return balances[_owner];
50   }
51 
52   function transfer(address _to, uint256 _value) public returns (bool) {
53     require(_value + marked[msg.sender] <= balances[msg.sender]);
54     require(_to != address(0));
55 
56     balances[msg.sender] = balances[msg.sender] - _value;
57     balances[_to] = balances[_to] + _value;
58     emit Transfer(msg.sender, _to, _value);
59     return true;
60   }
61 
62 }