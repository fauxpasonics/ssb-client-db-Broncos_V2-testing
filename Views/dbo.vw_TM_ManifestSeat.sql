SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create View
 [dbo].[vw_TM_ManifestSeat] AS
SELECT 
		dst.Seat SeatDs , --winner
       --sl.Seat SeatLp,
      tmms.seat_num ,
		tmms.num_seats ,
		tmms.seat_increment ,
		tmms.last_seat ,
       tmms.section_id ,
       dst.SSID_section_id SectionIdDs,
       dst.SectionName SectionNameDs ,
       tmms.section_name ,
       dst.RowName RowNameDs ,
       tmms.row_name ,
       tmms.id,
	   tmms.manifest_id, 
	   tmms.manifest_name,
	   tmms.section_type, 
	   tmms.row_id,
	   tmms.tm_section_name,
	   tmms.tm_row_name,
	   tmms.def_price_code,
	   tmms.default_class,
	   tmms.section_info1,
	   tmms.section_info2,
	   tmms.section_info3,
	   tmms.section_info4,
	   tmms.section_info5

FROM   ods.TM_ManifestSeat tmms
       INNER LOOP JOIN dbo.Lkp_SeatList sl ON sl.Seat >= tmms.seat_num
                                              AND sl.Seat < ( tmms.seat_num
                                                              + tmms.num_seats
                                                            )
       INNER JOIN dbo.DimSeat ( NOLOCK ) dst ON tmms.manifest_id = dst.ManifestId
                                                AND sl.Seat = dst.Seat
                                                AND tmms.row_id = dst.SSID_row_id
                                                AND tmms.section_id = dst.SSID_section_id
WHERE  manifest_id in ('94', '101')
GO
