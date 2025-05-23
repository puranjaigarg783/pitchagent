import { useRouter } from "next/router";

import { useEffect } from "react";

import AppLayout from "@/components/layouts/app";
import { SearchBoxPersisted } from "@/components/search-box";
import { Separator } from "@/components/ui/separator";
import { ContactsTable } from "@/components/visitors/contacts-table";

import { usePlan } from "@/lib/swr/use-billing";
import useViewers from "@/lib/swr/use-viewers";

export default function Visitors() {
  const router = useRouter();
  const { isFree, isTrial } = usePlan();
  const { viewers, isValidating, isFiltered } = useViewers();

  useEffect(() => {
    if (isFree && !isTrial) router.push("/documents");
  }, [isTrial, isFree]);

  return (
    <AppLayout>
      <div className="p-4 pb-0 sm:m-4 sm:py-4">
        <section className="mb-4 flex items-center justify-between md:mb-8 lg:mb-12">
          <div className="space-y-1">
            <h2 className="text-xl font-semibold tracking-tight text-foreground sm:text-2xl">
              All visitors
            </h2>
            <p className="text-xs text-muted-foreground sm:text-sm">
              See all your visitors in one place.
            </p>
          </div>
        </section>

        <div className="mb-2 flex justify-end gap-x-2">
          <div className="relative w-full sm:max-w-xs">
            <SearchBoxPersisted
              loading={isValidating}
              placeholder="Search visitors..."
              inputClassName="h-10"
            />
          </div>
        </div>

        <Separator className="bg-gray-200 dark:bg-gray-800" />
      </div>

      <div className="relative p-4 pt-0 sm:mx-4 sm:mt-4">
        {/* @ts-ignore */}
        <ContactsTable viewers={viewers} />
      </div>
    </AppLayout>
  );
}
