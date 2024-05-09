1 pragma solidity ^0.4.24;
2 
3 contract hbys{
4 
5     mapping(uint=>address) public addr;
6     uint public counter;
7     uint public bingo;
8     address owner;
9     
10     event Lucknumber(address holder,uint startfrom,uint quantity);
11     modifier onlyowner{require(msg.sender == owner);_;}
12     
13     
14     constructor() public{owner = msg.sender;}
15     
16     
17     function() payable public{
18         require(msg.value>0 && msg.value<=5*10**18);
19         getticket();
20     }
21     
22     
23     function getticket() internal{
24             //require(msg.sender==tx.origin);
25             uint fee;
26             fee+=msg.value/10;
27 	        owner.transfer(fee);
28 	        fee=0;
29 	        
30 	        
31 	        address _holder=msg.sender;
32 	        uint _startfrom=counter;
33 	        
34 	        uint ticketnum;
35             ticketnum=msg.value/(0.1*10**18);
36             uint _quantity=ticketnum;
37 	        counter+=ticketnum;
38 	        
39 	        uint8 i=0;
40             for (i=0;i<ticketnum;i++){
41                 	   addr[_startfrom+i]=msg.sender;
42                 
43             }
44             emit Lucknumber(_holder,_startfrom,_quantity);
45     }
46     
47     
48     
49     
50 /*
51 work out the target-number:bingo,and sent 2% of cash pool to the lucky guy.
52 
53 Join the two decimal of Dow Jones index's open price,close price,high price and low price in sequence.
54 eg. if the open price is 25012.33,the close price is 25103.12,the high price is 25902.26,
55 and the low price is 25001.49, then dji will be 33122649.
56 */
57     function share(uint dji) public  onlyowner{
58        require(dji>=0 && dji<=99999999);
59 
60        bingo=uint(keccak256(abi.encodePacked(dji)))%counter;
61 
62        addr[bingo].transfer(address(this).balance/50);
63     }
64        
65 }