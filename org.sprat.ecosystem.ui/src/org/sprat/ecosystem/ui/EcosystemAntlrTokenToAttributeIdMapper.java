package org.sprat.ecosystem.ui;

import java.util.regex.Pattern;

import org.eclipse.xtext.ui.editor.syntaxcoloring.AbstractAntlrTokenToAttributeIdMapper;
import org.eclipse.xtext.ui.editor.syntaxcoloring.DefaultHighlightingConfiguration;

import com.google.inject.Singleton;

@Singleton
public class EcosystemAntlrTokenToAttributeIdMapper extends AbstractAntlrTokenToAttributeIdMapper {

	private static final Pattern QUOTED = Pattern.compile("(?:^'([^']*)'$)|(?:^\"([^\"]*)\")$", Pattern.MULTILINE);
	private static final Pattern PUNCTUATION = Pattern.compile("\\p{Punct}*");

	@Override
	protected String calculateId(String tokenName, int tokenType) {
		//System.out.println(tokenName);
		if("'@'".equals(tokenName)) {
			return DefaultHighlightingConfiguration.KEYWORD_ID;
		}
		if(PUNCTUATION.matcher(tokenName).matches()) {
			return DefaultHighlightingConfiguration.PUNCTUATION_ID;
		}
		if(QUOTED.matcher(tokenName).matches()) {
			return DefaultHighlightingConfiguration.KEYWORD_ID;
		}
		if("RULE_STRING".equals(tokenName)) {
			return DefaultHighlightingConfiguration.STRING_ID;
		}
		if("RULE_INT".equals(tokenName) || "RULE_REAL".equals(tokenName)) {
			return DefaultHighlightingConfiguration.NUMBER_ID;
		}
		if("RULE_ML_COMMENT".equals(tokenName) || "RULE_SL_COMMENT".equals(tokenName)) {
			return DefaultHighlightingConfiguration.COMMENT_ID;
		}
		return DefaultHighlightingConfiguration.DEFAULT_ID;
	}
}

