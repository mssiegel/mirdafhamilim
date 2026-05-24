import { expect, test } from '@playwright/test';

test('loads the landing page from the dev server', async ({ page }) => {
  await page.goto('/');

  await expect(page).toHaveTitle('מִרְדָּף הַמִּלִּים');
  await expect(page.getByRole('heading', { name: 'מרדף המילים פועל' })).toBeVisible();
  await expect(
    page.getByText('תשתית עברית ומימין לשמאל מוכנה להמשך העבודה.'),
  ).toBeVisible();
  await expect(page.locator('html')).toHaveAttribute('dir', 'rtl');
});
