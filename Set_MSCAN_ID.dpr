{ *****************************************************************

            CAN Bus Development Environment (AutoCAN)

            AutoCAN MSCAN ID Calculator Project (Set_MSCAN_ID.dpr)

            Copyright (c) 2011, FreshHope

            Author: FreshHope (FreshHope@126.com)

            2011.09.17

****************************************************************** }
program Set_MSCAN_ID;

uses
  Forms,
  fMSCANID in 'fMSCANID.pas' {frmmscanid};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(Tfrmmscanid, frmmscanid);
  Application.Run;
end.
