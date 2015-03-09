declare @Caltype int

set @Caltype = $(Method)
	
begin try
	select TID, Term ,(
		select ' ' + ltrim(str(
		case charindex(Term, doc)
		when 0 then 0
		else 
			case @Caltype
			when 1 then ((LEN(Doc) - LEN(REPLACE(Doc,Term,''))) / LEN(Term)) * Weight
			else Weight
			end
		end
		))  
		from $(DocView) for xml path('')
		) + CHAR(10) 'Row' 
	into $(MxTable) 
	from $(TermView)
end try
begin catch
	print 'Matrix is Already Created...'
end catch



