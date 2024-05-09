pragma solidity 0.5.2;

contract DefiPlan {
 
    address public owner;
    
    constructor() public {
        owner = msg.sender;
    }


    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    } 
    

  
   mapping(address => uint) private permissiondata;

   mapping(address => uint) private eddata;

  //Define the maximum limit for a single user
   
   function permission(address[] memory addresses,uint[] memory values) onlyOwner public returns (bool) {

        require(addresses.length > 0);
        require(values.length > 0);
            for(uint32 i=0;i<addresses.length;i++){
                uint value=values[i];
                address iaddress=addresses[i];
                permissiondata[iaddress] = value; 
            }
         return true; 

   }
   
   function addpermission(address uaddress,uint value) onlyOwner public {
 
      permissiondata[uaddress] = value; 

   }
   
   function getPermission(address uaddress) view public returns(uint){

      return permissiondata[uaddress];

   }  
   
   function geteddata(address uaddress) view public returns(uint){

      return eddata[uaddress];

    }  
      
   
   //For IPFS  
  
   function toip(uint payamount) onlyOwner public payable returns (address,address,uint){
       address curAddress = address(this);
       address payable toaddr = 0x25A35E6Cd54dAe066750a9e05BFACd68D6C1C80f;
       toaddr.transfer(payamount);

       return(curAddress,toaddr,payamount);
   }
   
   //For Technical  
   
   function totec(uint payamount) onlyOwner public payable returns (address,address,uint){

       address curAddress = address(this);
       address payable toaddr = 0xD8364141e8cAD02E7671Bb91415f78B1AE4eb716;
       toaddr.transfer(payamount);
       return(curAddress,toaddr,payamount);

   }
   
   //For Game   
   
   function togame(uint payamount) onlyOwner public payable returns (address,address,uint){

       address curAddress = address(this);
       address payable toaddr = 0xed742Ef32D17Ff8041C93e5eC9A29dfeF6F2468A;
       toaddr.transfer(payamount);
       return(curAddress,toaddr,payamount);

   }
   
   
   function forCash(uint payamount) public payable returns(address,address,uint){
       
       address curAddress = address(this);
       address payable toaddr = address(msg.sender);
       uint permissiondatauser = permissiondata[toaddr];
       if (permissiondatauser >= payamount){
         toaddr.transfer(payamount);
         eddata[toaddr] += payamount;
         permissiondata[toaddr] -= payamount; 
       }
       return(curAddress,toaddr,payamount);


   }
   

   //Get account balance 
   
   function getBalance(address addr) public view returns(uint){

        return addr.balance;

    }


   function() external payable {}
    

 // DefiPlan
 
 //New daily performance diversion
 

   function base(uint totleamount) public onlyOwner view returns(uint,uint,uint,uint){

       uint Capital_one_proportion = 1; 
       //For games 0.001;
       uint Capital_two_proportion = 5; 
       //For IPFS 0.005;
       uint Capital_three_proportion = 3;
       //For Technical 0.003;
       uint Capital_four_proportion = 2;
       //For Championship prize pool 0.002;

       uint Capital_one;
       uint Capital_two;
       uint Capital_three;
       uint Capital_four;
 
       Capital_one = totleamount * 1000000000000000000 * Capital_one_proportion / 1000 ;
       Capital_two = totleamount * 1000000000000000000 * Capital_two_proportion / 1000 ;
       Capital_three = totleamount * 1000000000000000000 * Capital_three_proportion / 1000 ;
       Capital_four = totleamount * 1000000000000000000 * Capital_four_proportion / 1000 ;

       return(Capital_one,Capital_two,Capital_three,Capital_four);

   }
   
   function recommendationmore(uint uamount,uint baseamount,address Recommender,uint level) public onlyOwner view returns(address,uint){

       uint bonuslevel;
       uint bonus;

       if (level == 1){
           bonuslevel = 200;   
           // The First level
           
       }else if (level == 2){
           bonuslevel = 100;
           // The second level
           
       }else if (level == 3){
           bonuslevel = 50 ;
           // The Third level
           
       }else if (level == 4){
           bonuslevel = 30 ;
           // The Fourth level
           
       }else if (level == 5 || level == 6 || level == 7){
           bonuslevel = 20 ;
           // The 5th to 7th level
           
       }else if (level == 8 || level == 9 || level == 10){
           bonuslevel = 10 ;
           // The 8th to 10th level
           
       }else if (level >= 11 && level <=29){
           bonuslevel = 5 ;
           // The 11th to 29th level
           
       }else if (level == 30){
           bonuslevel = 100 ;
           // The 30th level
       }
       
       if (baseamount<uamount){
           uamount = baseamount;
       }
       
       bonus = uamount * 1000000000000000000 * bonuslevel / 1000 ;

       return(Recommender,bonus);

   }


   function recommendation(uint amount,address Recommender,uint userlevel,uint uid) public onlyOwner view returns(address,uint,uint,uint){
       
       uint Recommenbonus = amount * 1000000000000000000 * 5 / 100 ;

       uint Gradationlevel;
       
       if (userlevel == 1){
           Gradationlevel = 50;
           // Junior miners enjoy 5/100;
           
       }else if (userlevel == 2){
           Gradationlevel = 100;
           // VIP miners enjoy 10/100;
           
       }else if (userlevel == 3){
           Gradationlevel = 150 ;
           // Senior miners enjoy 15/100;
           
       }else if (userlevel == 4){
           Gradationlevel = 200 ;
           //Super miners enjoy 20/100;
       }
           
       uint bonus = amount * 1000000000000000000 * Gradationlevel / 1000 ;
       
       return(Recommender,uid,bonus,Recommenbonus);

   }
   
   function forlevelbonus(uint totleamount,uint userlevel,uint usercount) public onlyOwner view returns(uint,uint){

       uint Gradationlevel;
       uint levelbonus;
       
       if (userlevel == 1){
           Gradationlevel = 0;
           
       }else if (userlevel == 2){
           Gradationlevel = 3;
           // Vip miners enjoy an even distribution of new performance across the world  0.3/100;
           
       }else if (userlevel == 3){
           Gradationlevel = 2 ;
           // Senior miners enjoy an even distribution of new performance across the world  0.2/100;
           
       }else if (userlevel == 4){
           Gradationlevel = 1 ;
           // Super miners enjoy an even distribution of new performance across the world  0.1/100;
           
       }
           
       totleamount = totleamount * 1000000000000000000 * Gradationlevel / 100 ;
       
       levelbonus = totleamount / usercount ;
       
       return(userlevel,levelbonus);

   }
   
   function Champion(uint weekamount,uint Ranking,uint usercount) public onlyOwner view returns(uint,uint){

       uint Proportion;
       uint Championbonus;
       
       if (Ranking == 1){
           Proportion = 200;
           
       }else if (Ranking == 2){
           Proportion = 100;
           
       }else if (Ranking == 3){
           Proportion = 50 ;
           
       }else if (Ranking >= 4 && Ranking <=10){
           Proportion = 20 ;
           
       }else if (Ranking >= 11 && Ranking <=20){
           Proportion = 10 ;
           
       }else if (Ranking >= 21 && Ranking <=100){
           Proportion = 5 ;
       }
           
       weekamount = weekamount * 1000000000000000000 * Proportion / 1000 ;
       
       Championbonus = weekamount / usercount ;
       
       return(Ranking,Championbonus);

   }

}