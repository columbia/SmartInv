1 contract WavesPresale {
2     address public owner;
3     
4     struct Sale
5     {
6         uint amount;
7         uint date;
8     }
9 
10     mapping (bytes16 => Sale) public sales;
11     uint32 public numberOfSales;
12     uint public totalTokens;
13 
14     function WavesPresale() {
15         owner = msg.sender;
16         numberOfSales = 0;
17     }
18 
19     function changeOwner(address newOwner) {
20         if (msg.sender != owner) return;
21 
22         owner = newOwner;
23     }
24 
25     function newSale(bytes16 txidHash, uint amount, uint timestamp) {
26         if (msg.sender != owner) return;
27 
28         if (sales[txidHash].date == 0) {
29             sales[txidHash] = Sale({
30                     amount: amount,
31                     date: timestamp
32                 });
33             numberOfSales += 1;
34             totalTokens += amount;
35         } else {
36             throw;
37         }
38     }
39 
40     function getSaleDate(bytes16 txidHash) constant returns (uint, uint) {
41     	return (sales[txidHash].amount, sales[txidHash].date);
42     }
43 
44     function () {
45         // This function gets executed if a
46         // transaction with invalid data is sent to
47         // the contract or just ether without data.
48         // We revert the send so that no-one
49         // accidentally loses money when using the
50         // contract.
51         throw;
52     }
53 
54 }