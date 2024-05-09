1 // Refund contract for trust DAO #52
2 
3 contract DAO {
4     function balanceOf(address addr) returns (uint);
5     function transferFrom(address from, address to, uint balance) returns (bool);
6     uint public totalSupply;
7 }
8 
9 contract WithdrawDAO {
10     DAO constant public mainDAO = DAO(0xe4ae1efdfc53b73893af49113d8694a057b9c0d1);
11     address constant public trustee = 0xda4a4626d3e16e094de3225a751aab7128e96526;
12 
13     function withdraw(){
14         uint balance = mainDAO.balanceOf(msg.sender);
15 
16         if (!mainDAO.transferFrom(msg.sender, this, balance) || !msg.sender.send(balance))
17             throw;
18     }
19 
20     function trusteeWithdraw() {
21         trustee.send((this.balance + mainDAO.balanceOf(this)) - mainDAO.totalSupply());
22     }
23 }