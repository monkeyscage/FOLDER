contract UniversalFolder{

address public owner;             //standard needed for Alpha Layer and generic augmentation
string standard="ETHFOLDER.1.0";  //the blog standard
uint public EEcount;              // the amount of EE (Ethereum Entities) registered
uint public totExposed;           //the amount of EE exposed by the log
 
//creation
function UniversalFolder(address setOwner) {
owner=setOwner;
EEcount=1;
totExposed=1;
logs.push(log(o,0,1));
}

//change owner
function manager(address newOwner)returns(bool){
if(msg.sender!=owner)throw;
owner=newOwner;
return true;
}

//change owner
function setController(address o)returns(bool){
if(msg.sender!=owner)throw;
controller=o;
return true;
}
 
//add a new EE at the end of the log
function addEntity(address EE) returns(bool){
if((msg.sender!=owner)&&(msg.sender!=controller))throw;
logs.push(log(EE,EEcount-1,EEcount+1));
EEcount++;
totExposed++;
return true;
}



//delete a specific EE at a given index
function deleteEE(uint index) returns(bool){
if((msg.sender!=owner)&&(msg.sender!=controller))throw;
log l=logs[index];
logs[l.prev].next=l.next;
logs[l.next].prev=l.prev;
totExposed--;
return true;
}
 
//read the logs by index
function readLog(uint i)constant returns(uint,address,uint,uint,uint){
log l=logs[i];
return(logs.length,l.EE,l.prev,l.next,totExposed);
}

//the logs container
log[] logs;
//used to know in advance the logs structure
string public logInterface="a-Log|u-PrevLog|u-NextLog|u-TotExposed";

    struct log{
    address EE;
    uint prev;
    uint next;
   }
 
 
//destroy box
function kill(){
if (msg.sender != owner)throw;
selfdestruct(owner);
}
 
}
