1 pragma solidity 0.4.24;
2 
3 contract OCW {
4   mapping (uint256 => Mark) public marks;
5   string public constant name = "One Crypto World";
6   string public constant symbol = "OCW";
7   uint8 public constant decimals = 0;
8   string public constant memo = "Introducing One Crypto World (OCW)\n A blockchain is a ledger showing the quantity of something controlled by a user. It enables one to transfer control of that digital representation to someone else.\nOne Crypto World (OCW) is created and designed by Taiwanese Crypto Congressman Jason Hsu, who is driving for innovative policies in crypto and blockchain. It will be designed as a utility token without the nature of securities. OCW will not go on exchange; users will not be able to make any direct profit through OCW.\nOne Crypto World is a Proof of Support(POS). The OCW coin will only be distributed to global Key Opinion Leaders (KOLs), which makes it exclusive.\nBy using OCW coins, each KOL can contribute their valuable opinion to the Crypto Congressman’s policies.";
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
44   function totalMarks() public view returns (uint256) {
45     return markId;
46   }
47   
48   function totalSupply() public view returns (uint256) {
49     return totalSupply_;
50   }
51 
52   function balanceOf(address _owner) public view returns (uint256) {
53     return balances[_owner];
54   }
55 
56   function transfer(address _to, uint256 _value) public returns (bool) {
57     require(_value + marked[msg.sender] <= balances[msg.sender]);
58     require(_value <= balances[msg.sender]);
59     require(_value != 0);
60     require(_to != address(0));
61 
62     balances[msg.sender] = balances[msg.sender] - _value;
63     balances[_to] = balances[_to] + _value;
64     emit Transfer(msg.sender, _to, _value);
65     return true;
66   }
67 
68 }