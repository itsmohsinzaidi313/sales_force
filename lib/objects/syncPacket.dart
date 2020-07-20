class SyncPacket{
  String id;
  String serverId;
  String module;
  String operation;
  String url;
  String createdOn;
  String isUsed = '0';
  SyncPacket({this.module, this.operation, this.url, this.createdOn, this.serverId});

  getList(){
    return [this.serverId, this.module, this.operation, this.url, this.createdOn, isUsed];
  }

  getMap(){
    return {'server_id':this.serverId, 'module':this.module, 'operation':this.operation, 'url':this.url, 'createdon':this.createdOn, 'is_used':this.isUsed};
  }
}