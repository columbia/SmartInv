1 pragma solidity ^0.4.17;
2 
3 contract Distributor
4 {
5     address owner = msg.sender;
6     address newOwner = msg.sender;
7     
8     function ChangeOwner(address _newOwner)
9     public
10     {
11         require(msg.sender == owner);
12         newOwner = _newOwner;
13     }
14     
15     function ConfirmOwner()
16     public
17     {
18         require(newOwner==msg.sender);
19         owner=newOwner;
20     }
21     
22     function Withdrawal()
23     public
24     payable
25     {
26         owner.transfer(this.balance);
27     }
28     
29     function Send(address[] addr, uint[] val)
30     public
31     payable
32     {
33         require(val.length==addr.length);
34         uint total;
35         for (uint j=0; j<val.length; j++)
36         {
37             require(addr[j]!=0x0);
38             total+=val[j];
39         }
40         if(msg.value>=total)
41         {
42             for (uint i=0; i<addr.length; i++)
43             {
44                 addr[i].transfer(val[i]);
45             }
46         }
47     }
48 }