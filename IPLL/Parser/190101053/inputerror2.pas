PROGRAM STATS
VAR
	SUM,PRODUCT,SUMSQ,I,VALUE,MEAN,VARIANCE : INTEGER;
	TEMP,I,P : REAL
BEGIN
	SUM := 0;
	SUMSQ := 0;
	PRODUCT := 0.5;
	P := 0.1;
	$
	FOR I := 1 TO 100 DO
	BEGIN
		READ(VALUE);
		$
		SUM := SUM + VALUE;
		P := SUM * TEMP;
		#
		SUMSQ := SUMSQ + VALUE * VALUE
	END;
	MEAN := SUM DIV 100;
	#
	VARIANCE := SUMSQ DIV 100 - MEAN * MEAN;
	WRITE(MEAN,VARIANCE);
END.