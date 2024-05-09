1 pragma solidity^0.4.17;
2 
3 contract BountyEscrow {
4 
5   address public admin;
6 
7   mapping(address => bool) public authorizations;
8 
9   event Bounty(
10     address indexed sender,
11     uint256 indexed amount
12   );
13 
14   event Payout(
15     uint256 indexed id,
16     bool indexed success
17   );
18 
19   function BountyEscrow() public {
20     admin = msg.sender;
21   }
22 
23   // Default bounty function
24   function () public payable {
25     Bounty(msg.sender, msg.value);
26   }
27 
28 
29   modifier onlyAdmin {
30     require(msg.sender == admin);
31     _;
32   }
33 
34   modifier authorized {
35     require(msg.sender == admin || authorizations[msg.sender]);
36     _;
37   }
38 
39   function payout(uint256[] ids, address[] recipients, uint256[] amounts) public authorized {
40     require(ids.length == recipients.length && ids.length == amounts.length);
41     for (uint i = 0; i < recipients.length; i++) {
42       Payout(ids[i], recipients[i].send(amounts[i]));
43     }
44   }
45 
46   function deauthorize(address agent) public onlyAdmin {
47     authorizations[agent] = false;
48   }
49 
50   function authorize(address agent) public onlyAdmin {
51     authorizations[agent] = true;
52   }
53 
54 }