1 // Refund contract for extraBalance
2 // Amounts to be paid are tokenized in another contract and allow using the same refund contract as for theDAO
3 // Though it may be misleading, the names 'DAO', 'mainDAO' are kept here for the ease of code review
4 
5 contract DAO {
6     function balanceOf(address addr) returns (uint);
7     function transferFrom(address from, address to, uint balance) returns (bool);
8     uint public totalSupply;
9 }
10 
11 contract WithdrawDAO {
12     DAO constant public mainDAO = DAO(0x5c40ef6f527f4fba68368774e6130ce6515123f2);
13     address constant public trustee = 0xda4a4626d3e16e094de3225a751aab7128e96526;
14 
15     function withdraw(){
16         uint balance = mainDAO.balanceOf(msg.sender);
17 
18         if (!mainDAO.transferFrom(msg.sender, this, balance) || !msg.sender.send(balance))
19             throw;
20     }
21 
22     function trusteeWithdraw() {
23         trustee.send((this.balance + mainDAO.balanceOf(this)) - mainDAO.totalSupply());
24     }
25 }